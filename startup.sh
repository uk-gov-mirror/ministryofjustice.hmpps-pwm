#!/bin/bash

echo 'Generating configuration...'
echo "${CONFIG_XML_BASE64}" | base64 -d > PwmConfiguration.xml.tpl

export SES_PASSWORD=$(echo $SES_JSON | jq -r '.ses_smtp_password')
export SES_USERNAME=$(echo $SES_JSON | jq -r '.ses_smtp_user')

CONFIG_PASSWORD_HASH=$(htpasswd -bnBC 10 "" "${CONFIG_PASSWORD}" | tr -d ':\n') \
  envsubst <PwmConfiguration.xml.tpl >"${PWM_APPLICATIONPATH}/PwmConfiguration.xml"

unset SES_PASSWORD
unset SES_USERNAME

echo 'Starting PWM...'
catalina.sh run
