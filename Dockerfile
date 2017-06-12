FROM node

WORKDIR /opt

RUN git clone https://github.com/timeoff-management/application.git timeoff-management 

WORKDIR /opt/timeoff-management
RUN git checkout v0.6.2
RUN npm install mysql && npm install

EXPOSE 3000
VOLUME /opt/timeoff-management/config
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "bash", "/docker-entrypoint.sh"]
