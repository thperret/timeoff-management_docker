#!/bin/bash

if [[ -z $NODE_ENV ]]; then
	export NODE_ENV=production
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
	CRYPTO_SECRET=$(cat /opt/timeoff-management/config/crypto_secret)
fi

if [[ -z $APP_URL ]]; then
	APP_URL=http://app.timeoff.management
fi

if [[ -z $ALLOW_ACCOUNTS_CREATION ]]; then
	ALLOW_ACCOUNTS_CREATION=true
fi

cat > /opt/timeoff-management/config/app.json << EOF
{
  "allow_create_new_accounts" : $ALLOW_ACCOUNTS_CREATION,
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
  "application_domain" : "$APP_URL",
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
    "FR": {
      "name": "France",
      "bank_holidays": [
        {
          "date": "2016-03-27",
          "name": "P\u00e2ques"
        },
        {
          "date": "2016-05-05",
          "name": "L'Ascension"
        },
        {
          "date": "2016-11-01",
          "name": "La Toussaint"
        },
        {
          "date": "2016-12-31",
          "name": "la Saint-Sylvestre"
        },
        {
          "date": "2017-05-01",
          "name": "La f\u00eate du Travail"
        },
        {
          "date": "2017-05-25",
          "name": "L'Ascension"
        },
        {
          "date": "2017-06-05",
          "name": "Le lundi de Pentec\u00f4te"
        },
        {
          "date": "2017-12-24",
          "name": "La veille de No\u00ebl"
        },
        {
          "date": "2017-12-25",
          "name": "No\u00ebl"
        },
        {
          "date": "2017-12-31",
          "name": "la Saint-Sylvestre"
        },
        {
          "date": "2018-05-10",
          "name": "L'Ascension"
        },
        {
          "date": "2016-03-28",
          "name": "Le lundi de P\u00e2ques"
        },
        {
          "date": "2016-05-01",
          "name": "La f\u00eate du Travail"
        },
        {
          "date": "2017-04-16",
          "name": "P\u00e2ques"
        },
        {
          "date": "2017-06-04",
          "name": "Pentec\u00f4te"
        },
        {
          "date": "2017-07-14",
          "name": "La f\u00eate nationale"
        },
        {
          "date": "2017-11-11",
          "name": "L'Armistice"
        },
        {
          "date": "2018-04-02",
          "name": "Le lundi de P\u00e2ques"
        },
        {
          "date": "2018-05-21",
          "name": "Le lundi de Pentec\u00f4te"
        },
        {
          "date": "2018-06-17",
          "name": "F\u00eate des P\u00e8res"
        },
        {
          "date": "2018-07-14",
          "name": "La f\u00eate nationale"
        },
        {
          "date": "2018-11-11",
          "name": "L'Armistice"
        },
        {
          "date": "2018-12-24",
          "name": "La veille de No\u00ebl"
        },
        {
          "date": "2018-12-25",
          "name": "No\u00ebl"
        },
        {
          "date": "2016-05-16",
          "name": "Le lundi de Pentec\u00f4te"
        },
        {
          "date": "2016-06-19",
          "name": "F\u00eate des P\u00e8res"
        },
        {
          "date": "2016-08-15",
          "name": "L'Assomption"
        },
        {
          "date": "2016-12-24",
          "name": "La veille de No\u00ebl"
        },
        {
          "date": "2016-12-25",
          "name": "No\u00ebl"
        },
        {
          "date": "2017-05-08",
          "name": "F\u00eate de la Victoire 1945"
        },
        {
          "date": "2017-08-15",
          "name": "L'Assomption"
        },
        {
          "date": "2018-04-01",
          "name": "P\u00e2ques"
        },
        {
          "date": "2018-05-01",
          "name": "La f\u00eate du Travail"
        },
        {
          "date": "2018-05-08",
          "name": "F\u00eate de la Victoire 1945"
        },
        {
          "date": "2018-05-20",
          "name": "Pentec\u00f4te"
        },
        {
          "date": "2018-05-27",
          "name": "F\u00eate des M\u00e8res"
        },
        {
          "date": "2018-08-15",
          "name": "L'Assomption"
        },
        {
          "date": "2018-12-31",
          "name": "la Saint-Sylvestre"
        },
        {
          "date": "2016-05-08",
          "name": "F\u00eate de la Victoire 1945"
        },
        {
          "date": "2016-05-15",
          "name": "Pentec\u00f4te"
        },
        {
          "date": "2016-05-29",
          "name": "F\u00eate des M\u00e8res"
        },
        {
          "date": "2016-07-14",
          "name": "La f\u00eate nationale"
        },
        {
          "date": "2016-11-11",
          "name": "L'Armistice"
        },
        {
          "date": "2017-04-17",
          "name": "Le lundi de P\u00e2ques"
        },
        {
          "date": "2017-05-28",
          "name": "F\u00eate des M\u00e8res"
        },
        {
          "date": "2017-06-18",
          "name": "F\u00eate des P\u00e8res"
        },
        {
          "date": "2017-11-01",
          "name": "La Toussaint"
        },
        {
          "date": "2018-11-01",
          "name": "La Toussaint"
        },
        {
          "date": "2016-03-27",
          "name": "Heure d'\u00e9t\u00e9"
        },
        {
          "date": "2016-10-30",
          "name": "Heure d'hiver"
        },
        {
          "date": "2017-03-26",
          "name": "Heure d'\u00e9t\u00e9"
        },
        {
          "date": "2017-10-29",
          "name": "Heure d'hiver"
        },
        {
          "date": "2018-03-25",
          "name": "Heure d'\u00e9t\u00e9"
        },
        {
          "date": "2018-10-28",
          "name": "Heure d'hiver"
        },
        {
          "date": "2016-01-01",
          "name": "Jour de l'an"
        },
        {
          "date": "2017-01-01",
          "name": "Jour de l'an"
        },
        {
          "date": "2018-01-01",
          "name": "Jour de l'an"
        }
      ]
    },
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

npm run-script db-update
npm start
