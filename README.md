# do-k8s-tf-8thavehotel
Deploy a Kubernetes cluster on DigitalOcean using Terraform.

## Requirements

* [DigitalOcean](https://www.digitalocean.com/) account
* DigitalOcean Token [In DO's settings/tokens/new](https://cloud.digitalocean.com/settings/tokens/new)
* [Terraform](https://www.terraform.io/)
* https://keybase.io/tobymccann

### On Ubuntu 

export TF_VER="0.12.9"
sudo apt-get update && sudo apt-get install -y apt-transport-https wget unzip
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
sudo snap install doctl

wget https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip
unzip terraform_${TF_VER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -v

### On Mac

With brew installed, all tools can be installed with

```bash
brew install terraform kubectl 
```

Do all the following steps from a development machine - ranger.3ktek.com. This one will be subsequently used to access the cluster via `kubectl`.

## Generate private / public keys

```
ssh-keygen -f ~/.ssh/do-key-ecdsa -t ecdsa -b 521
```

The system will prompt you for a file path to save the key, we will go with `~/.ssh/id_rsa` in this tutorial.

## Add your public key in the DigitalOcean control panel

[Do it here](https://cloud.digitalocean.com/settings/security). Name it and paste the public key just below `Add SSH Key`.

## Add this key to your SSH agent

```bash
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
```

## Invoke Terraform

We put our DigitalOcean token in the file `./secrets/DO_TOKEN` (this directory is mentioned in `.gitignore`, of course, so we don't leak it)

Then we setup the environment variables (step into `this repository` root).

```bash
export TF_VAR_do_token=$(cat ./secrets/DO_TOKEN)
export TF_VAR_ssh_fingerprint=$(ssh-keygen -E MD5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}' | sed 's/MD5://g')
```

If you are using an older version of OpenSSH (<6.9), replace the last line with
```bash
export TF_VAR_ssh_fingerprint=$(ssh-keygen -lf ~/.ssh/id_rsa.pub | awk '{print $2}')
```

There is a convenience script for you in `./setup_terraform.sh`. Invoke it as

```bash
. ./setup_terraform.sh
```

Optionally, you can customize the datacenter *region* via:
```bash
export TF_VAR_do_region=fra1
```
The default region is `nyc3`. You can find a list of available regions from [DigitalOcean](https://developers.digitalocean.com/documentation/v2/#list-all-regions).

After setup, call `terraform apply`

```bash
terraform apply
```

That should do! `kubectl` is configured, so you can just check the nodes (`get no`) and the pods (`get po`).
https://www.digitalocean.com/community/cheatsheets/getting-started-with-kubectl-a-kubectl-cheat-sheet

# following this AFTER cluster is live:

## Download the Configuration File
## Automated Certificate Management (Recommended)
doctl is the most convenient way to manage your Kubernetes configuration file. When doctl is available on the PATH of your administration machine and configured with API keys to access your account, it uses an exec-credential plugin to dynamically grab the client-certificate and client-key data at runtime every time kubectl is called.

After you have both kubectl and doctl, download your Kubernetes cluster config file. Use the name of your cluster instead of example-cluster-01 in the following command.

doctl kubernetes cluster kubeconfig save example-cluster-01
Copy
This downloads the kubeconfig for the cluster and automatically merges it with any existing configuration from ~/.kube/config.

Then:

https://www.digitalocean.com/community/tutorials/how-to-automate-deployments-to-digitalocean-kubernetes-with-circleci
