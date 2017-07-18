#!/usr/bin/env bash

gcloud compute http-health-checks create kube-apiserver-health-check \
  --description "Kubernetes API Server Health Check" \
  --port 8080 \
  --request-path /healthz

gcloud compute target-pools create kubernetes-target-pool \
  --http-health-check=kube-apiserver-health-check \
  --region us-central1

gcloud compute target-pools add-instances kubernetes-target-pool \
  --instances controller0,controller1,controller2

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
  --region us-central1 \
  --format 'value(address)')

gcloud compute forwarding-rules create kubernetes-forwarding-rule \
  --address ${KUBERNETES_PUBLIC_ADDRESS} \
  --ports 6443 \
  --target-pool kubernetes-target-pool \
  --region us-central1
