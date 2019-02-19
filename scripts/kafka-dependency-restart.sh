#!/bin/bash

kubectl  get po | grep admin-backend | awk '{print $1}' | xargs kubectl  delete po

sleep 25


kubectl  get po | grep  admin-frontend | awk '{print $1}' | xargs kubectl  delete po

sleep 10

kubectl  get po | grep beacon | awk '{print $1}' | xargs kubectl  delete po

sleep 20

kubectl  get po | grep broker | awk '{print $1}' | xargs kubectl  delete po

sleep 30

kubectl  get po | grep dz-cache-wrapper | awk '{print $1}' | xargs kubectl  delete po

sleep 15


kubectl  get po | grep  dz-connector-admin | awk '{print $1}' | xargs kubectl  delete po

sleep 20

kubectl  get po | grep dz-configuration-enricher  | awk '{print $1}' | xargs kubectl  delete po

sleep 10

kubectl  get po | grep  dz-aggregation-processor-egress | awk '{print $1}' | xargs kubectl  delete po

sleep 45

kubectl  get po | grep dz-aggregation-processor-ingress  | awk '{print $1}' | xargs kubectl  delete po

sleep 45

kubectl  get po | grep  google | awk '{print $1}' | xargs kubectl  delete po

sleep 30

kubectl  get po | grep connector-event-router  | awk '{print $1}' | xargs kubectl  delete po

sleep 30


kubectl  get po | grep dz-connector-adobe-heartbeat  | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep dz-connector-amplitude  | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep aws  | awk '{print $1}' | xargs kubectl  delete po

sleep 10

kubectl  get po | grep brightcove  | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep connector-configuration-enricher  | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep  datadog | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep  connector-elasticsearch | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep  connector-cassandra | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep connector-event-aggregator  | awk '{print $1}' | xargs kubectl  delete po

sleep 8


kubectl  get po | grep  s3- | awk '{print $1}' | xargs kubectl  delete po

sleep 12

kubectl  get po | grep  splunk | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep yubora  | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep  connector-retry-handler | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep  redshift | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep  nielsen- | awk '{print $1}' | xargs kubectl  delete po

sleep 8


kubectl  get po | grep  newrelic- | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep mapr-db  | awk '{print $1}' | xargs kubectl  delete po

sleep 8

kubectl  get po | grep connector-keenio  | awk '{print $1}' | xargs kubectl  delete po

sleep 8


kubectl  get po | grep mixpanel  | awk '{print $1}' | xargs kubectl  delete po



