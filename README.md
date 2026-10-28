# Inception of Things

A system administration and DevOps project designed to introduce modern Kubernetes deployment strategies, cluster orchestration, and GitOps workflows.

---

## Overview

The Inception of Things project focuses on transitioning from traditional container environments to modern container orchestration using Kubernetes. It provides a structured approach to building clusters, managing deployments, handling ingress routing, and implementing continuous deployment using GitOps practices.

---

## Repository Structure

```text
.
├── p1/                 # Part 1: Vagrant & K3s Cluster setup
│   ├── Vagrantfile
│   └── scripts/
├── p2/                 # Part 2: Kubernetes Applications, Services & Ingress
│   └── conf/
├── p3/                 # Part 3: K3d & Argo CD (GitOps)
│   └── conf/
└── bonus/              # Bonus: Local GitLab CI/CD integration
    └── conf/
```

---

## Project Breakdown

### Part 1: K3s and Vagrant
* **Objective:** Provision a multi-node Kubernetes cluster locally using Vagrant and VirtualBox.
* **Implementation:** 
  * A server virtual machine (`s_vm`) running a K3s control plane.
  * An agent virtual machine (`sw_vm`) joining the cluster as a worker node using a shared cluster token.
  * Automated provisioning executed via shell scripts.

### Part 2: K3s and Applications
* **Objective:** Deploy simple web applications onto the K3s cluster and expose them externally.
* **Implementation:**
  * Custom `Deployment` and `Service` manifest files written in YAML.
  * An Ingress controller configured to route traffic to different applications based on paths or host headers.
  * Local host mapping configured via `/etc/hosts`.

### Part 3: K3d and Argo CD (GitOps)
* **Objective:** Implement a lightweight local Kubernetes environment using K3d and adopt a GitOps workflow with Argo CD.
* **Implementation:**
  * Cluster creation using K3d.
  * Installation and configuration of Argo CD within an isolated namespace (`argocd`).
  * Continuous synchronization enabling Argo CD to reconcile the cluster state against the specified Git repository.

### Bonus: Local GitLab Integration
* **Objective:** Deploy a self-hosted GitLab instance inside the cluster and integrate it with CI/CD pipelines and Argo CD.
* **Implementation:**
  * Execution of a local GitLab deployment within a dedicated `gitlab` namespace.
  * Automation of build triggers and manifest updates upon code commits.

---

## Prerequisites

Ensure the following dependencies are installed on the host machine prior to deployment:
* VirtualBox (or equivalent supported hypervisor)
* Vagrant
* Docker Engine
* K3d CLI
* Kubectl CLI

---

## Deployment Instructions

### Part 1: Provisioning the Vagrant Cluster
```bash
cd p1
vagrant up
vagrant ssh s_vm
kubectl get nodes
```

### Part 3: K3d and Argo CD Setup
```bash
cd p3
# Create the K3d cluster with required port forwarding
k3d cluster create mycluster --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer"

# Install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

---

## Troubleshooting & Maintenance
* **Virtual Machine Cleanup:** In cases where Vagrant instances fail to terminate, use `vboxmanage list vms` to identify and remove orphan virtual machines.
* **Resource Allocation:** Ensure sufficient memory and CPU resources are allocated to the virtual machine provider and Docker daemon to avoid provisioning timeouts.
