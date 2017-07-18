# kubernetes-scripts
scripts to make the hard way go faster

All scripts are from the work done at: https://github.com/kelseyhightower/kubernetes-the-hard-way

These are simply bash scripts to cut down on the copy paste as me step through the tutorial at the July DevOps KC meetup.

Blog:
https://aaronblythe.github.io/kubernetes/2017/07/07/kubernetes-hands-on-tutorial.html

https://twitter.com/DevOpsKC/status/884419240337575936

NOTE the following will not be kept up.  This is simply for a one-time meeting.


Steps:

# Setup

* Download: https://cloud.google.com/sdk/docs/quickstart-mac-os-x
* On local machine(if on Mac):

```
./scripts/setup.sh
# open a new tab
./script/setup.sh
# Log on to https://console.cloud.google.com/home/dashboard enable compute API
# Do not move on until
gcloud compute instances list
# returns: Listed 0 items.
```

# [Cloud Infrastructure Provisioning](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/01-infrastructure-gcp.md)

Start the hard way and discuss along the way:
Run locally

```
./scripts/01-infrastructure-gcp.sh
```
Check the UI of Google cloud.

# [Setting up a CA and TLS Cert Generation](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/02-certificate-authority.md)

Check that you have wget installed

```
which wget
```

if not:

```
brew install wget
```

Then move on with tutorial

```
./scripts/02-certificate-authority_mac.sh
```

You will have to input your password and enter passphrases.

# [Setting up TLS Client Bootstrap and RBAC Authentication](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-auth-configs.md)

```
./scripts/03-auth-configs.sh
```

# [Bootstrapping a H/A etcd cluster](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-etcd.md)

NOTE: the etcd will need to be intalled on each of the controllers

```
for host in controller0 controller1 controller2; do
  gcloud compute scp scripts/04-etcd.sh ${host}:~/
done
```

Then you will need to ssh to each machine.  I open multiple tabs for this.

```
gcloud compute ssh controller0
gcloud compute ssh controller1
gcloud compute ssh controller2
```

Then from each machine run:

```
./04-etcd.sh
```

Then from the first machine run:

```
sudo etcdctl \
  --ca-file=/etc/etcd/ca.pem \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  cluster-health
```

# [Bootstrapping a H/A Kubernetes Control Plane](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-controller.md)

NOTE: the the components of the control plane will need to be intalled on each of the controllers

Run this from your local machine to get the file up to the machine:

```
for host in controller0 controller1 controller2; do
  gcloud compute scp scripts/05-kubernetes-controller.sh ${host}:~/
done
```

You should still be logged on to each machine.

```
./05-kubernetes-controller.sh
sudo kubectl get componentstatuses
```

This runs so fast that you may get:

```
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```

Runnig a second time seems to resolve this.

Now you need to run this on your local Mac:

```
./scripts/05-kubernetes-controller-local.sh
```


# [Bootstrapping Kubernetes Workers](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/06-kubernetes-worker.md)

First on the controller0

```
kubectl create clusterrolebinding kubelet-bootstrap \
  --clusterrole=system:node-bootstrapper \
  --user=kubelet-bootstrap
```

NOTE: the the components of for the workers will need to be intalled on each of the workers

Run this from your local machine to get the file up to the machine:

```
for host in worker0 worker1 worker2; do
  gcloud compute scp scripts/06-kubernetes-worker.sh ${host}:~/
done
```

Then you will need to ssh to each machine. I open a terminal with different colors for this.

```
gcloud compute ssh worker0
gcloud compute ssh worker1
gcloud compute ssh worker2
```

Then from each worker machine run:

```
./06-kubernetes-worker.sh
```

Approve the TLS certs as shown at the bottom of https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/06-kubernetes-worker.md

# [Configuring the Kubernetes Client - Remote Access](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/07-kubectl.md)

Run:

```
./scripts/07-kubectl.sh
```

You will have to enter your password.

# [Managing the Container Network Routes](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/08-network.md)

Run:

```
./scripts/08-network.sh
```

# [Deploying the Cluster DNS Add-on](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/09-dns-addon.md)

Run:

```
./scripts/09-dns-addon.sh
kubectl --namespace=kube-system get pods
```

# [Smoke Test](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/10-smoke-test.md)

Run:

```
./scripts/10-smoke-test.sh
```

# [Cleaning Up](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/11-cleanup.md)

Run:

```
./scripts/11-cleanup.sh
```

