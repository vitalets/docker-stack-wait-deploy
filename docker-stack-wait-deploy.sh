#!/usr/bin/env bash
# Script to wait until all services in stack are deployed.
# Usage:
# ./docker-stack-wait-deploy.sh [stack-name]

stack_name=$1

while true; do
  all_services_done=1
  has_errors=0
  updatable_output=""

  service_ids=$(docker stack services -q $stack_name)

  # check all services in stack
  for service_id in $service_ids; do
    service_name=$(docker service inspect --format '{{.Spec.Name}}' $service_id)
    # see: https://github.com/moby/moby/issues/28012
    service_state=$(docker service inspect --format '{{if .UpdateStatus}}{{.UpdateStatus.State}}{{else}}created{{end}}' $service_id)

    case "$service_state" in
      created|completed)
        ;;
      paused|rollback_completed)
        has_errors=1
        ;;
      *)
        all_services_done=0
        ;;
    esac

    service_echo_ps=$(docker service ps $service_id --filter "desired-state=running")
    service_echo_header="STATUS ($service_name): $service_state"
    updatable_output="$updatable_output\n$service_echo_header\n$service_echo_ps\n"
  done

  updatable_output="$updatable_output\n"

  # clear updatable output per line (using 'tput ed' does not work correctly)
  while [ ${updatable_output_lines:-0} -gt 0 ]
  do
    tput cuu 1 # move cursor up one line
    tput el # clear line
    ((updatable_output_lines--))
  done

  printf "$updatable_output"
  updatable_output_lines=$(printf "$updatable_output" | wc -l | tr -d '\n')

  # check if all services done
  if [ "$all_services_done" == "1" ]; then
    if [ "$has_errors" == "1" ]; then
      echo "Deployment failed."
      # todo: show error message
      exit 1
    else
      echo "Deployment successful."
      exit 0
    fi
  else
    sleep 1
  fi
done
