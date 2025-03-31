# P2P technical assignment

## Task

For this assignment, we would like you to fully automate with “one click”:

- The deployment of a local kubernetes cluster on your machine.
- The deployment of the **cosmos rpc node** on the **provider testnet network** to the local kubenetes cluster on your machine.
- The deployment of grafana and prometheus to your local kubernetes cluster to view the resources used such as cpu / memory / disk space etc..

You are **not limited t**o the above list or the tooling you use in order to do this -

Use the tools you would in a production environment to show us your skillset, approach and feel free to demonstrate additional techniques if you have time.

**Definition of done:** A fully automated one click deployment of a syncing / synced **cosmos rpc node** on the **provider testnet network** on the local kubernetes cluster with grafana dashboards to monitor basic metrics.

## Procedure

### Infrastructure

- Deploy an AWS VM using terraform.
- Deploy Kubernetes single node cluster using ansible and kubeadm.

### Steps:

- Clone the repository.
- Change the directory to `terraform`.
- make sure the AWS key pair is added to private keys and has the same name as the one on AWS.
- Run `terraform init`.
- Run `terraform apply`. This will create an EC2 instance and install Kubernetes cluster `v1.31` on it. At the end of the process, it will create a file `admin.conf` that can be used to connect to cluster..

## Improvements

- Keep terraform state in S3 bucket.