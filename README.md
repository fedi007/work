# **🛠️ Deploying Jenkins on a Minikube Kubernetes Cluster**

### Prerequisites

Ensure you have the following tools installed:

-kubectl

-minikube

-Docker (for the Minikube driver)

### 1️⃣ Installing Minikube

Run the following commands to install Minikube on a Linux system:

<pre lang="md"> ```curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 ``` </pre>
<pre lang="md"> ```minikube sudo install minikube-linux-amd64 /usr/local/bin/minikube ``` </pre>


### 2️⃣ Starting Minikube

<pre lang="md"> ```minikube start --driver=docker ``` </pre>

![image](https://github.com/user-attachments/assets/ca84bce4-4920-4390-b077-d48602f7e304)

minikube cluster is added to the kubeconfig file:

![image](https://github.com/user-attachments/assets/f680020e-9e6a-404c-88d4-999a6994136f)


Verify that the nodes is ready for scheduling pods

![image](https://github.com/user-attachments/assets/68fdd56d-52ec-4e34-9f44-731acd1bad72)

Overview about the Cluster : 

![alt text](image-4.png)

### 3️⃣ Deploying Jenkins on Minikube

Prepared the need Kubernetes manifests:

- A Deployment for Jenkins

- A Service of type NodePort to expose Jenkins 

Once the pod is ruuning , I forwarded the service already created using:

<pre lang="md"> ```minikube service jenkins -n jenkins ``` </pre> ,and the server is ready and responding :

![alt text](image.png)


### 4️⃣ Blue/Green Node.js Deployment

A sample Node.js application is deployed in the nodeapp namespace with both blue and green deployments.

The service is initially pointing to the blue deployment.

**The application is accessible at: http://192.168.49.2:30080/**


To switch the service to point to the green deployment:
 
<pre lang="md"> ```kubectl patch service node-app \
  -p '{"spec": {"selector": {"app": "node-app", "version": "green"}}}' ``` </pre>

### ⚙️ Automating the Deployment

The setup is automated using a bash automation script , to run it do :
 
<pre lang="md"> ```chmod 777 automation.sh ``` </pre>
<pre lang="md"> ```./automation.sh ``` </pre>


# **☁️ Deploying Jenkins on AWS EKS using Terraform**

### 1️⃣ Setting Up EKS

- Navigate to the eks-tf/ directory.

- Initialize Terraform and apply the configurations using:

<pre lang="md"> ```terraform init ``` </pre>
<pre lang="md"> ```terraform workspace new assessment``` </pre>
<pre lang="md"> ```terraform apply ``` </pre>

![alt text](image-1.png)

Then you can see that the cluster is creating from the AWS console : 

![alt text](image-2.png)

Once the cluster is created :

![alt text](image-3.png)

### 2️⃣ Installing Jenkins on EKS with Helm


After that , I am going now to launch jenkins ( with JDK 21) on the eks cluster using a helm chart based on my configuration (AWS/EKS)

I will use and efs voulme for creating the persistent volume and a claim for mounting Jenkins volume.



1.Create a namespace: 


<pre lang="md"> ```kubectl create namespace adad-jenkins ``` </pre>

2.Install Jenkins using Helm (with JDK 21 and custom config):

<pre lang="md"> ```helm install jenkins jenkins_chart/ -n adad-jenkins  ``` </pre>

once the jenkins is ready :

![alt text](image-5.png)

I will port forward to the service to access it : 

![alt text](image-6.png)

Now We can access jenkins UI: 

![alt text](image-7.png)

### 3️⃣ Integrating Jenkins with Kubernetes


Install the Kubernetes plugin in Jenkins and configure it to connect to the same EKS cluster it is running in.

This allows Jenkins to manage dynamic agents (pods) inside the EKS cluster.

![alt text](image-8.png) 


### 4️⃣  Demostrating a blue green deployment with Jenkins

Initially, the application is live with the blue deployment as you can see in the screenshoot

![alt text](image-9.png)

and the service routes traffic to the blue pods.

![alt text](image-10.png)

then after define the Jenkins pipline under (nodjsapp/Jenkinsfile) with steps :


 ## Deploy Green Version : 
 A new version of the application (green) is deployed in parallel alongside the blue version. It does not receive traffic yet.

 ![alt text](image-12.png)

 ## Wait for Readiness
The pipeline waits until the green pods are up and running successfully.

![alt text](image-13.png)

 ## Smoke Testing
The pipeline performs a basic health check on the green deployment (e.g., via HTTP call or port-forwarding) to verify it's functioning correctly.

![alt text](image-14.png)

## Switch Traffic to Green
If the smoke test passes, the service selector is updated to point to the green deployment, effectively switching  traffic from blue to green.

![alt text](image-15.png) 

## Decommission Blue
The blue deployment is scaled down or stopped to free up resources.

![alt text](image-16.png)

![alt text](image-11.png)

## Pipeline Results


![alt text](image-17.png)