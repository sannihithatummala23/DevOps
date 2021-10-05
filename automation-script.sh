#!/bin/bash

# Make a directory project and change to that directory:
mkdir project ; cd project
echo " "
echo "Automation script Initiated. Downloading required files for installation: "
echo " "

# Cloning DevOps Repository that has required K8 and Prometheus files:
git clone https://github.com/sannihithatummala23/DevOps.git

#As we have already created a Docker image and uploaded it to Docker hub,
# next step, which is k8 deployment will retrive the image from there.

#Sleep 5 Seconds, just in case for the Repository to download:
sleep 5

# Change directory to DevOps dir
cd DevOps

echo " "
echo "Creating namespace monitoring"
echo " "
# Create a nameSpace for k8 monitoring stack:
kubectl create namespace monitoring

echo " "
echo "creating k8 deployment for the romannumeral-converter application:"
echo " "
#Execute the k8 deployment file in the namespace created:
kubectl create -f deployment.yml -n monitoring

echo " "
echo "creating k8 service for the romannumeral-converter application:"
echo " "
#Execute the k8 service file in the namespace created:
kubectl create -f service.yml -n monitoring

# Sleep for 60 seconds, just in case for the k8 resources to be up & running stable:
sleep 60

echo " "
echo "Port-forwarding Cluster-ip service to localhost:8080 as a background process"
kubectl port-forward service/romannumeralconverter-svc -n monitoring 8080:8080 &

echo " "
echo "Downloading Prometheus docker image"
#Pull prometheus by executing the docker command:
docker pull prom/prometheus

echo " "

echo "#################"
echo "Update the <path/to/file>/project/DevOps/prometheus.yml > 'spring-actuator' targets:[xx:xx:xx:xx:8080] IP address configuration with the below k8 Service 'romannumeralconverter-svc' created Cluster-IP address:"
echo " "
kubectl describe svc romannumeralconverter-svc -n monitoring | grep IPs | cut -d ":" -f2
echo "##################"

#Deploy prometheus by executing the docker command:
#docker run -d --name prometheus -p 9090:9090 -v <path/to/file>/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

echo " "
echo "Pulling & deploying Grafana docker image:"
docker run -d --name grafana -p 3000:3000 grafana/grafana
echo " "
