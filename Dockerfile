FROM node

WORKDIR /opt

RUN git clone https://github.com/timeoff-management/application.git timeoff-management 

WORKDIR /opt/timeoff-management
RUn git checkout ff4d92af84401a8a14136e6bcdcc4dcae4ea0560
RUN npm install mysql && npm install

EXPOSE 3000
VOLUME /opt/timeoff-management/config
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "bash", "/docker-entrypoint.sh"]
