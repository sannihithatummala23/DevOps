#!/bin/bash

# Make a directory project and change to that directory:
mkdir project
cd project

# Cloning DevOps Repository that has required K8 and Prometheus files:
git clone https://github.com/sannihithatummala23/DevOps.git

#As we have already created a Docker image and uploaded it to Docker hub,
# next step, which is k8 deployment will retrive the image from there.

#Sleep 15 Seconds
sleep 15

# Change directory to DevOps dir
cd DevOps

#Execute the k8 deployment and service files
kubectl create -f deployment.yml
kubectl create -f service.yml

# Sleep for 45 seconds
sleep 45

# Port-forwarding Cluster-ip service to localhost:8080 as a background process
kubectl port-forward service/romannumeralconverter-svc 8080:8080 &

#Pull prometheus by executing the docker command:
docker pull prom/prometheus

# Sleep for 15 seconds
sleep 15

#Deploy prometheus by executing the docker command:
#docker run -d --name prometheus -p 9090:9090 -v <path/to/file>/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

#Deploy Grafana by executing the docker command:
docker run -d --name grafana -p 3000:3000 grafana/grafana
