# Dockerfile
> The Dockerfile which is a multi-stage build, in the first stage, clones the project from the GitHub url.
> In the second stage, it copies the required files from the first stage and helps to build the final image required to run the spring-boot application using the embedded Tomcat server.

# automation-script
> Automation-script consists of shell commands to deploy the application on a docker container and setup monitoring, alerting to the deployed application.

# Deployment.yml
> This k8 file deployment is used to run the dockerized image of the project. It is setup with Liveness, Readiness and StartUp Probes to make the application is ready to server the traffic.

# Service.yml
> This k8 file contains instructions to serve the traffic on certain ports of the K8 cluster for the deployment associated.
