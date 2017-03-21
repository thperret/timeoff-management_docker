#!/bin/bash

if [[ -z $NODE_ENV ]]; then
	NODE_ENV=production
fi

if [[ -n $SENDER_MAIL ]]; then
	SEND_MAILS=true
	if [[ -z $SMTP_HOST ]]; then
		echo "You need to configure the SMTP_HOST variable to enable mails sending"
		SEND_MAILS=false
	fi
	if [[ -z $SMTP_PORT ]]; then
		echo "You need to configure the SMTP_PORT variable to enable mails sending"
		SEND_MAILS=false
	fi
	if [[ -z $SMTP_USER ]]; then
		echo "You need to configure the SMTP_USER variable to enable mails sending"
		SEND_MAILS=false
	fi
	if [[ -z $SMTP_PASSWORD ]]; then
		echo "You need to configure the SMTP_PASSWORD variable to enable mails sending"
		SEND_MAILS=false
	fi
else
	SEND_MAILS=false
	SMTP_HOST="localhost"
	SMTP_PORT=25
	SMTP_USER=user
	SMTP_PASSWORD=password
fi

if [[ -e /opt/timeoff-management/config/crypto_secret ]]; then
	CRYPTO_SECRET=$(cat /opt/timeoff-management/config/crypto_secret)
else
	echo -n $(tr -dc A-Za-z0-9_\#\(\)\!: < /dev/urandom | head -c 40 | xargs) > /opt/timeoff-management/config/crypto_secret
	CRYPTO_SECRET=$(cat crypto_secret)
fi

cat > /opt/timeoff-management/config/app.json << EOF
{
  "allow_create_new_accounts" : true,
  "send_emails"              : $SEND_MAILS,
  "application_sender_email" : "$SENDER_MAIL",
  "email_transporter" : {
    "host" : "$SMTP_HOST",
    "port" : $SMTP_PORT,
    "auth" : {
      "user" : "$SMTP_USER",
      "pass" : "$SMTP_PASSWORD"
    }
  },
  "crypto_secret" : "$CRYPTO_SECRET",
  "application_domain" : "http://app.timeoff.management",
  "promotion_website_domain" : "http://timeoff.management"
}
EOF

cat > /opt/timeoff-management/config/db.json << EOF
{
  "development": {
    "dialect": "sqlite",
    "storage": "./db.development.sqlite"
  },
  "test": {
    "username": "root",
    "password": null,
    "database": "database_test",
    "host": "127.0.0.1",
    "dialect": "mysql"
  },
EOF

if [[ -n $MYSQL_HOST && -n $MYSQL_USER && -n $MYSQL_PASSWORD ]]; then
	if [[ -z $MYSQL_DATABASE ]]; then
		MYSQL_DATABASE="timeoffmanagement"
	fi
	cat >> /opt/timeoff-management/config/db.json << EOF
  "production": {
    "username": "$MYSQL_USER",
    "password": "$MYSQL_PASSWORD",
    "database": "$MYSQL_DATABASE",
    "host": "$MYSQL_HOST",
    "dialect": "mysql"
  }
}
EOF
else
	cat >> /opt/timeoff-management/config/db.json << EOF
  "production": {
    "dialect": "sqlite",
    "storage": "./db.production.sqlite"
  }
}
EOF
fi

cat > /opt/timeoff-management/config/localisation.json << EOF
{
  "countries" : {
    "DE" : {
      "name" : "Germany",
      "bank_holidays" : [
        {
          "name" : "New Year Day",
          "date" : "2016-01-01"
        },
        {
          "name" : "Good Friday",
          "date" : "2016-03-25"
        },
        {
          "name" : "Easter Monday",
          "date" : "2016-03-28"
        },
        {
          "name" : "Labour Day",
          "date" : "2016-05-01"
        },
        {
          "name" : "Ascension",
          "date" : "2016-05-05"
        },
        {
          "name" : "Whit Monday",
          "date" : "2016-05-16"
        },
        {
          "name" : "Day of German Unity",
          "date" : "2016-10-03"
        },
        {
          "name" : "Christmas Day",
          "date" : "2016-12-26"
        },
        {
          "name" : "St. Stephens Day",
          "date" : "2016-12-27"
        }
      ]
    },
    "IS" : {
      "name" : "Iceland"
    },
    "ES" : {
      "name" : "Spain",
      "bank_holidays" : [
        {
          "name" : "New Year Day",
          "date" : "2016-01-01"
        },
        {
          "name" : "Epiphany",
          "date" : "2016-01-06"
        },
        {
          "name" : "Good Friday",
          "date" : "2016-03-25"
        },
        {
          "name" : "Labour Day",
          "date" : "2016-05-01"
        },
        {
          "name" : "Assumption Day",
          "date" : "2016-08-15"
        },
        {
          "name" : "Hispanic Day",
          "date" : "2016-10-12"
        },
        {
          "name" : "All Saints Day",
          "date" : "2016-11-01"
        },
        {
          "name" : "Constitution Day",
          "date" : "2016-12-06"
        },
        {
          "name" : "Immaculate Conception Day",
          "date" : "2016-12-08"
        },
        {
          "name" : "Christmas Day",
          "date" : "2016-12-25"
        }
      ]
    },
    "UK" : {
      "name" : "United Kingdom",
      "default" : 1,
      "bank_holidays" : [
        {
          "name" : "New Year Day",
          "date" : "2016-01-01"
        },
        {
          "name" : "Good Friday",
          "date" : "2016-03-25"
        },
        {
          "name" : "Easter Monday",
          "date" : "2016-03-28"
        },
        {
          "name" : "Early May Bank Holiday",
          "date" : "2016-05-02"
        },
        {
          "name" : "Spring Bank Holiday",
          "date" : "2016-05-30"
        },
        {
          "name" : "Boxing Day",
          "date" : "2016-12-26"
        },
        {
          "name" : "Christmas Day",
          "date" : "2016-12-27"
        }
      ]
    },
    "US" : {
      "name" : "United States",
      "bank_holidays" : [
        {
          "name" : "New Year Day",
          "date" : "2016-01-01"
        },
        {
          "name" : "Martin Luther King Day",
          "date" : "2016-01-18"
        },
        {
          "name" : "Memorial Day",
          "date" : "2016-05-30"
        },
        {
          "name" : "Independence Day",
          "date" : "2016-07-04"
        },
        {
          "name" : "Labor Day",
          "date" : "2016-09-05"
        },
        {
          "name" : "Veterans Day",
          "date" : "2016-11-11"
        },
        {
          "name" : "Thanksgiving",
          "date" : "2016-11-24"
        },
        {
          "name" : "Christmas Day",
          "date" : "2016-12-26"
        }
      ]
    }
  }
}
EOF

npm start
