#!/usr/bin/env bash

kubectl create clusterrolebinding serviceaccounts-cluster-admin \
  --clusterrole=cluster-admin \
  --group=system:serviceaccounts


kubectl create -f https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/services/kubedns.yaml

kubectl --namespace=kube-system get svc

kubectl create -f https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/deployments/kubedns.yaml

kubectl --namespace=kube-system get pods
