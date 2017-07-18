#!/usr/bin/env bash

kubectl get nodes \
  --output=jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address} {.spec.podCIDR} {"\n"}{end}'

gcloud compute routes create kubernetes-route-10-200-0-0-24 \
  --network kubernetes-the-hard-way \
  --next-hop-address 10.240.0.20 \
  --destination-range 10.200.0.0/24

gcloud compute routes create kubernetes-route-10-200-1-0-24 \
  --network kubernetes-the-hard-way \
  --next-hop-address 10.240.0.21 \
  --destination-range 10.200.1.0/24

gcloud compute routes create kubernetes-route-10-200-2-0-24 \
  --network kubernetes-the-hard-way \
  --next-hop-address 10.240.0.22 \
  --destination-range 10.200.2.0/24


