#!/bin/bash

# Make a directory project and change to that directory:
mkdir project ; cd project
echo " "
echo "***Automation script Initiated. Downloading required files for installation***"
echo " "

# Cloning DevOps Repository that has required K8 and Prometheus files:
git clone https://github.com/sannihithatummala23/DevOps.git

#As we have already created a Docker image by building the Spring-boot project and uploaded it to Docker hub, Next step is to deploy k8 resources by retrieving the image from docker hub.

#Sleep 5 Seconds, just in case for the Repository to download:
sleep 5

# Change directory to DevOps dir
cd DevOps

echo " "
echo "***Creating namespace monitoring***"
echo " "
# Create a nameSpace for k8 monitoring stack:
kubectl create namespace monitoring

echo " "
echo "***Creating k8 deployment for the romannumeral-converter application***"
echo " "
#Execute the k8 deployment file in the namespace created:
kubectl create -f deployment.yml -n monitoring

echo " "
echo "***Creating k8 service for the romannumeral-converter application***"
echo " "
#Execute the k8 service file in the namespace created:
kubectl create -f service.yml -n monitoring

echo " "
echo "Sleep for 60 seconds, just in case for the k8 resources to be up & running stable"
sleep 60

echo " "
echo "***Port-forwarding Cluster-ip service to localhost:8080 as a background process***"
kubectl port-forward service/romannumeralconverter-svc -n monitoring 8080:8080 &
echo " "
echo "***Access RomanNumeralConverter Applicaion: http://localhost:8080/romannumeral?query=1 ***"

echo " "
echo "***Pulling & deploying Grafana docker image***"
docker run -d --name grafana -p 3000:3000 grafana/grafana
echo " "
echo "***Access Grafana: http://localhost:3000/ using credentials: admin/admin. You will be prompeted to update password after logging in!***"

echo " "
echo "***Downloading Prometheus docker image***"
#Pull prometheus by executing the docker command:
docker pull prom/prometheus

echo " "

echo "################# MANUAL STEP #################"
echo "***Update the <path/to/file>/project/DevOps/prometheus.yml > 'spring-actuator' targets:[xx:xx:xx:xx:8080] IP address configuration with the k8 Service 'romannumeralconverter-svc' Cluster-IP address created below***"
kubectl describe svc romannumeralconverter-svc -n monitoring | grep IPs | cut -d ":" -f2

echo " "

echo "***Once the prometheus.yml file is updated with the IP address, deploy prometheus by executing the below docker command***"
echo " "
echo "docker run -d --name prometheus -p 9090:9090 -v <path/to/file>/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus"
echo " "
echo "Access Prometheus: http://localhost:9090/ ***"
echo "##################"
