#!/bin/bash

echo 'Generating configuration...'
echo "${CONFIG_XML_BASE64}" | base64 -d > PwmConfiguration.xml.tpl
CONFIG_PASSWORD_HASH=$(htpasswd -bnBC 10 "" "${CONFIG_PASSWORD}" | tr -d ':\n') \
  envsubst <PwmConfiguration.xml.tpl >"${PWM_APPLICATIONPATH}/PwmConfiguration.xml"

SES_PASSWORD=$(echo $SES_JSON | jq -r '.ses_smtp_password')
SES_USERNAME=$(echo $SES_JSON | jq -r '.ses_smtp_user')

envsubst '$LDAP_PASSWORD' < "${PWM_APPLICATIONPATH}/PwmConfiguration.xml"
envsubst '$SES_PASSWORD' < "${PWM_APPLICATIONPATH}/PwmConfiguration.xml"
envsubst '$SES_USERNAME' < "${PWM_APPLICATIONPATH}/PwmConfiguration.xml"
echo 'Starting PWM...'
catalina.sh run
