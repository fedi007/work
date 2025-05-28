# Deploying Jenkins on a minkkube K8S Cluster:

We need to have Kubectl installed and minikube !

Steps :

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64


sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube start --driver=docker

![image](https://github.com/user-attachments/assets/ca84bce4-4920-4390-b077-d48602f7e304)

minikube cluster is added to the kubeconfig file:

![image](https://github.com/user-attachments/assets/f680020e-9e6a-404c-88d4-999a6994136f)


Verify that the nodes is ready for scheduling pods

![image](https://github.com/user-attachments/assets/68fdd56d-52ec-4e34-9f44-731acd1bad72)

Overview about the Cluster : 

![alt text](image-4.png)

#Deploying Jenkins :

After I prepared the deployement file and the service with type NodePort which will expose jenkins , then apply the config yaml files in the dedicated namespace jenkins.

Once the pod is ruuning , I forwarded the service already created using:

minikube service jenkins -n jenkins , and the server is ready and responding :

![alt text](image.png)


# Creating  a Blue / Green Nodjs Deplyoment :

The node sample app is created in the namespace nodeapp in which both green and blue deployments are applied

The serivce which expose the deployement on port 30080 is pointed on the blue deployment

and it can be reached from http://192.168.49.2:30080/ and to switch to the green deployment which is already applied , the service pointed on the blue should be patched to the green deploy using :

kubectl patch service node-app \
  -p '{"spec": {"selector": {"app": "node-app", "version": "green"}}}'


The setup is automated using a bash automation script , to run it do :

chmod 777 automation.sh 

./automation.sh


# Second Method , creating kubernetes cluster from EKS and using terraform :

The configs files are present in the eks-tf folder , after initialzing terraform and creating the dedicated aws account and using the workspace assesment :

![alt text](image-1.png)

Then you can see that the cluster is creating from the AWS console : 

![alt text](image-2.png)

Once the cluster is created :

![alt text](image-3.png)

After that , I am going now to launch jenkins ( with JDK 21) on the eks cluster using a helm chart , in which I will do updated based on my config (AWS/EKS)

I will use and efs voulme for creating the persistent volume and a claim for mounting Jenkins volume.

After creating a dedicated namespace I will do :

helm install jenkins jenkins_chart/ -n adad-jenkins 

once the jekins is ready :

![alt text](image-5.png)

I will port forward to the service to access it : 

![alt text](image-6.png)

Now We can access : 

![alt text](image-7.png)

I installed the Kubernetes plugin so I can connect the jenkins pod to the EKS in which its running :

![alt text](image-8.png) 