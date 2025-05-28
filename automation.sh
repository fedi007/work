#!/bin/bash

set -e

echo ">> Checking if Minikube is installed..."
if ! command -v minikube &> /dev/null; then
    echo ">> Installing Minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
else
    echo ">> Minikube is already installed."
fi

echo ">> Adding user to Docker group (if not already)..."
sudo usermod -aG docker $USER
echo ">> Please log out and log back in for Docker group change to take effect if this is your first time running the script."

echo ">> Starting Minikube with Docker driver..."
minikube start --driver=docker

echo ">> Verifying cluster status..."
kubectl get nodes

echo ">> Deploying Jenkins..."

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  labels:
    app: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
      - name: jenkins
        image: jenkins/jenkins:lts
        ports:
        - containerPort: 8080
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30070
EOF

echo ">> Deploying Node.js App..."

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-app
  labels:
    app: node-app
    version: blue
spec:
  replicas: 2
  selector:
    matchLabels:
      app: node-app
      version: blue
  template:
    metadata:
      labels:
        app: node-app
        version: blue
    spec:
      containers:
      - name: nodejs
        image: node:16-alpine
        command: ["node", "-e"]
        args:
          - |
            const http = require('http');
            http.createServer((req, res) => {
              res.writeHead(200, {'Content-Type': 'text/plain'});
              res.end('Assement app');
            }).listen(3000);
        ports:
        - containerPort: 3000
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: node-app
spec:
  selector:
    app: node-app
    version: blue
  ports:
    - port: 80
      targetPort: 3000
      nodePort: 30080
  type: NodePort
EOF

echo ">> Setup complete."
echo ">> Access Jenkins: http://$(minikube ip):30070"
echo ">> Access Node.js App: http://$(minikube ip):30081"