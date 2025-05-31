🛠️ Deploying Jenkins on a Minikube Kubernetes Cluster

Prerequisites

Ensure you have the following tools installed:

-kubectl

-minikube

-Docker (for the Minikube driver)

1️⃣ Installing Minikube

Run the following commands to install Minikube on a Linux system:

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

2️⃣ Starting Minikube

minikube start --driver=docker

![image](https://github.com/user-attachments/assets/ca84bce4-4920-4390-b077-d48602f7e304)

minikube cluster is added to the kubeconfig file:

![image](https://github.com/user-attachments/assets/f680020e-9e6a-404c-88d4-999a6994136f)


Verify that the nodes is ready for scheduling pods

![image](https://github.com/user-attachments/assets/68fdd56d-52ec-4e34-9f44-731acd1bad72)

Overview about the Cluster : 

![alt text](image-4.png)

3️⃣ Deploying Jenkins on Minikube

Prepared the need Kubernetes manifests:

- A Deployment for Jenkins

- A Service of type NodePort to expose Jenkins 

Once the pod is ruuning , I forwarded the service already created using:

minikube service jenkins -n jenkins , and the server is ready and responding :

![alt text](image.png)


4️⃣ Blue/Green Node.js Deployment

A sample Node.js application is deployed in the nodeapp namespace with both blue and green deployments.

The service is initially pointing to the blue deployment.

The application is accessible at: http://192.168.49.2:30080/ 


To switch the service to point to the green deployment:

kubectl patch service node-app \
  -p '{"spec": {"selector": {"app": "node-app", "version": "green"}}}'

⚙️ Automating the Deployment

The setup is automated using a bash automation script , to run it do :

chmod 777 automation.sh 

./automation.sh


☁️ Deploying Jenkins on AWS EKS using Terraform

1️⃣ Setting Up EKS

- Navigate to the eks-tf/ directory.

- Initialize Terraform and apply the configurations using 

   ---> terraform init
   ---> terraform workspace new assessment
   --->    terraform apply
![alt text](image-1.png)

Then you can see that the cluster is creating from the AWS console : 

![alt text](image-2.png)

Once the cluster is created :

![alt text](image-3.png)

2️⃣ Installing Jenkins on EKS


After that , I am going now to launch jenkins ( with JDK 21) on the eks cluster using a helm chart , in which I will do updated based on my config (AWS/EKS)

I will use and efs voulme for creating the persistent volume and a claim for mounting Jenkins volume.

After creating a dedicated namespace I will do :

helm install jenkins jenkins_chart/ -n adad-jenkins 

once the jenkins is ready :

![alt text](image-5.png)

I will port forward to the service to access it : 

![alt text](image-6.png)

Now We can access : 

![alt text](image-7.png)

3️⃣ Integrating Jenkins with Kubernetes


Install the Kubernetes plugin in Jenkins and configure it to connect to the same EKS cluster it is running in.

This allows Jenkins to manage dynamic agents (pods) inside the EKS cluster.

![alt text](image-8.png) 