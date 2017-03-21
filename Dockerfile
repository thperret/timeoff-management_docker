FROM node

WORKDIR /opt

RUN git clone https://github.com/timeoff-management/application.git timeoff-management

WORKDIR /opt/timeoff-management
RUN npm install && npm install mysql

EXPOSE 3000
VOLUME /opt/timeoff-management/config
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "bash", "/docker-entrypoint.sh"]
