# Deploying Jenkins on a minkkube K8S Cluster:

We need to have Kubectl installed and minikube !

Steps :

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64


sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube start --driver=docker

![image](https://github.com/user-attachments/assets/ca84bce4-4920-4390-b077-d48602f7e304)

minikube cluster is added to the kubeconfig file:

![image](https://github.com/user-attachments/assets/f680020e-9e6a-404c-88d4-999a6994136f)


Verify that the nodes is ready and ready for scheduling pods

![image](https://github.com/user-attachments/assets/68fdd56d-52ec-4e34-9f44-731acd1bad72)


#Deploying Jenkins :

After I prepared the deployement file and the service with type NodePort which will expose jenkins , then apply the config yaml files in the dedicated namespace jenkins.


