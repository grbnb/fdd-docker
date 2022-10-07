FROM grbhq/nginx-openjdk:v1

ENV FDD_DIR=/fdd \
    PS1="\u@\h:\w \$ "

WORKDIR ${FDD_DIR}
#VOLUME ${FDD_DIR}/mysql

#配置 启动文件
ADD ./*.sh ${FDD_DIR}/
ADD my.cnf /etc/mysql/my.cnf
COPY ./config ${FDD_DIR}/config

# 后端
RUN wget https://raw.githubusercontent.com/fengxiaoruia/QL-Emotion-jar/main/QL-Emotion.jar -O ${FDD_DIR}/QL-Emotion.jar && \
    chmod +x ${FDD_DIR}/*.sh && \
    mkdir -p ${FDD_DIR}/sample && cp -r ${FDD_DIR}/config/* ${FDD_DIR}/sample/

# 前端
RUN rm -rf /etc/nginx/conf.d/default.conf /usr/share/nginx/html/* && \
    apk add --no-cache --update git mysql && rm -f /var/cache/apk/* && \
    git clone https://github.com/fengxiaoruia/QL-Emotion-View.git /usr/share/nginx/html/ && \
    rm -rf /usr/share/nginx/html/.git
ADD default.conf /etc/nginx/conf.d/

EXPOSE 3306 8080

#CMD ["/docker-entrypoint.sh"]
ENTRYPOINT ["sh", "docker-entrypoint.sh"]