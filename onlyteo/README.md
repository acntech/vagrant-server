# AcnTech Ubuntu Server with Kubernetes

## Server VM
Set up the Ubuntu Server so that Minikube is accessable from a client VM.

### Prerequisites
The server must be provisioned with the `kubernetes` Puppet environment:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "acntech/ubuntu-server"

  # Enable provisioning with puppet
  config.vm.provision "puppet" do |puppet|
    puppet.environment = "kubernetes"
    puppet.environment_path = "../provision/puppet/environments"
    puppet.module_path = "../provision/puppet/modules"
  end
end
```

### Setup

1. In the `Vagrantfile` of the server add a private network with a static IP:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "acntech/ubuntu-server"

  config.vm.network "private_network", ip: "10.0.50.10"
end
```

2. Add hostname DNS records to the server:
```bash
sudo vi /etc/hosts
```
```
10.0.50.5	dev.acn
10.0.50.10	k8s.acn
```

3. Start Minikube (will default to a Docker driver):
```bash
minikube start
```

## Client VM
Set up a Linux VM as a client for the Ubuntu Server running Minikube.

### Prerequisites
The client must have the `kubectl` Kubernetes Control CLI installed.

### Setup

1. In the `Vagrantfile` of the client (developer VM) add a private network with a static IP:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "acntech/ubuntu-developer"

  config.vm.network "private_network", ip: "10.0.50.5"
end
```

2. Add hostname DNS records to the client:
```bash
sudo vi /etc/hosts
```
```
10.0.50.5	dev.acn
10.0.50.10	k8s.acn
```

3. Create a profile directory for `minikube` in the users home:
```bash
mkdir -p ~/.kube/profiles/minikube
```

4. Copy client certificate and key for the profile:
```bash
scp vagrant@k8s.acn:~/.minikube/profiles/minikube/client.crt ~/.kube/profiles/minikube/
scp vagrant@k8s.acn:~/.minikube/profiles/minikube/client.key ~/.kube/profiles/minikube/
```

5. Create and use `kubectl` config context for the `minikube`:
```bash
kubectl config set-cluster k8s.acn --insecure-skip-tls-verify=true --server=https://k8s.acn
kubectl config set-credentials minikube --client-certificate=/home/vagrant/.kube/profiles/minikube/client.crt --client-key=/home/vagrant/.kube/profiles/minikube/client.key
kubectl config set-context minikube@k8s.acn/default --user=minikube  --cluster=k8s.acn --namespace=default
kubectl config use-context minikube@k8s.acn/default
```

6. Run `kubectl` commands on the `minikube`:
```bash
kubectl get pods
```
