#!/usr/bin/env bash

gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-f

gcloud compute networks create kubernetes-the-hard-way --mode custom

gcloud compute networks subnets create kubernetes \
  --network kubernetes-the-hard-way \
  --range 10.240.0.0/24 \
  --region us-central1


gcloud compute firewall-rules create allow-internal \
  --allow tcp,udp,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

gcloud compute firewall-rules create allow-external \
  --allow tcp:22,tcp:3389,tcp:6443,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 0.0.0.0/0

gcloud compute firewall-rules create allow-healthz \
  --allow tcp:8080 \
  --network kubernetes-the-hard-way \
  --source-ranges 130.211.0.0/22,35.191.0.0/16

gcloud compute firewall-rules list --filter "network=kubernetes-the-hard-way"

gcloud compute addresses create kubernetes-the-hard-way --region=us-central1

gcloud compute addresses list kubernetes-the-hard-way

gcloud compute instances create controller0 \
 --boot-disk-size 200GB \
 --can-ip-forward \
 --image ubuntu-1604-xenial-v20170307 \
 --image-project ubuntu-os-cloud \
 --machine-type n1-standard-1 \
 --private-network-ip 10.240.0.10 \
 --subnet kubernetes

gcloud compute instances create controller1 \
 --boot-disk-size 200GB \
 --can-ip-forward \
 --image ubuntu-1604-xenial-v20170307 \
 --image-project ubuntu-os-cloud \
 --machine-type n1-standard-1 \
 --private-network-ip 10.240.0.11 \
 --subnet kubernetes

gcloud compute instances create controller2 \
 --boot-disk-size 200GB \
 --can-ip-forward \
 --image ubuntu-1604-xenial-v20170307 \
 --image-project ubuntu-os-cloud \
 --machine-type n1-standard-1 \
 --private-network-ip 10.240.0.12 \
 --subnet kubernetes

gcloud compute instances create worker0 \
 --boot-disk-size 200GB \
 --can-ip-forward \
 --image ubuntu-1604-xenial-v20170307 \
 --image-project ubuntu-os-cloud \
 --machine-type n1-standard-1 \
 --private-network-ip 10.240.0.20 \
 --subnet kubernetes \
 --metadata startup-script='#! /bin/bash
apt-get update
apt-get install -y socat
EOF'

gcloud compute instances create worker1 \
 --boot-disk-size 200GB \
 --can-ip-forward \
 --image ubuntu-1604-xenial-v20170307 \
 --image-project ubuntu-os-cloud \
 --machine-type n1-standard-1 \
 --private-network-ip 10.240.0.21 \
 --subnet kubernetes \
 --metadata startup-script='#! /bin/bash
apt-get update
apt-get install -y socat
EOF'

gcloud compute instances create worker2 \
 --boot-disk-size 200GB \
 --can-ip-forward \
 --image ubuntu-1604-xenial-v20170307 \
 --image-project ubuntu-os-cloud \
 --machine-type n1-standard-1 \
 --private-network-ip 10.240.0.22 \
 --subnet kubernetes \
 --metadata startup-script='#! /bin/bash
apt-get update
apt-get install -y socat
EOF'


gcloud compute instances list
