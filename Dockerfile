FROM alpine

COPY docker-stack-wait-deploy.sh /

CMD ["cat", "/docker-stack-wait-deploy.sh"]
