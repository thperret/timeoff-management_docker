FROM node

WORKDIR /opt

RUN git clone https://github.com/timeoff-management/application.git timeoff-management 

WORKDIR /opt/timeoff-management
RUN git checkout c476af3c627f2d86d4827504776cfa082af17152
RUN npm install mysql && npm install

EXPOSE 3000
VOLUME /opt/timeoff-management/config
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "bash", "/docker-entrypoint.sh"]
