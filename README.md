*This project has been created as part of the 42 curriculum by szapata-.*

# Inception of Things

## Description

The Inception of Things project is a system administration and DevOps module designed to expand upon traditional containerization concepts by introducing modern Kubernetes deployment strategies, cluster orchestration, and GitOps workflows.

The primary goal of this project is to transition from single-node Docker environments to multi-node Kubernetes clusters, implementing automated provisioning, routing traffic via Ingress controllers, and managing declarative continuous deployment.

### Overview

* **Part 1: K3s and Vagrant:** Provisioning a local multi-node Kubernetes cluster using Vagrant and K3s (one server node and one worker node).
* **Part 2: K3s and Applications:** Deploying containerized web applications onto the K3s cluster and configuring an Ingress controller to route external traffic based on host headers and paths.
* **Part 3: K3d and Argo CD:** Establishing a lightweight local Kubernetes environment using K3d and implementing a GitOps continuous deployment pipeline with Argo CD.
* **Bonus Part: Local GitLab Integration:** Setting up a self-hosted local GitLab instance within the cluster integrated with custom CI/CD pipelines.

## Instructions

### Prerequisites

Ensure the following dependencies are installed on the host machine prior to execution:

* VirtualBox (or equivalent supported hypervisor)
* Vagrant
* Docker Engine
* K3d CLI
* Kubectl CLI

### Execution and Setup

#### Part 1: Vagrant and K3s Cluster

Navigate to the `p1` directory and provision the virtual machines:

```bash
cd p1
vagrant up
```

Access the control plane server node to verify the node status:

```bash
vagrant ssh s_vm
kubectl get nodes
```

#### Part 2: Kubernetes Applications and Ingress

Navigate to the `p2` directory and apply the Kubernetes deployment, service, and ingress manifests:

```bash
cd p2/conf
kubectl apply -f .
```

Verify that the deployments, services, and ingress rules are active:

```bash
kubectl get all
kubectl get ingress
```

#### Part 3: K3d and Argo CD (GitOps)

Create a local K3d cluster with required port forwarding rules and deploy Argo CD:

```bash
cd p3
k3d cluster create iot-cluster --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Apply the Argo CD application manifest to begin continuous synchronization:

```bash
kubectl apply -n argocd -f conf/application.yaml
```

## Resources

### Documentation & References

* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [K3s Lightweight Kubernetes Documentation](https://docs.k3s.io/)
* [K3d Documentation](https://k3d.io/)
* [Argo CD Documentation](https://argo-cd.readthedocs.io/)
* [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)

### Artificial Intelligence Usage

Artificial intelligence tools were used during the development of this project for the following specific tasks and components:

* **Documentation:** Assisting in generating and formatting this README according to the required structure and standards.
* **Syntax Verification:** Reviewing YAML manifest files for Kubernetes resource configurations (Ingress, Deployment, and Argo CD Application resources).
* **Troubleshooting:** Diagnosing provisioning logic and network initialization flags within Vagrant shell scripts.