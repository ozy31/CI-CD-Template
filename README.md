# TODO application deployed in HELM on AWS Cloud via JENKINS


## Description


This application aims to create a to-do app in Node.js as a web application with yarn on AWS Instances


# STEPS TO FOLLOW

- Create the source code which specifies your needs. In this case we'll take levarege from one of the app that can be found publicly written in node.js .


-  Create the Dockerfile 

-   Since our app is written in node.js language, we need to use very lightweigth distrubution for this app which is  ``` alpine ``` as base image.

-   If we decide to use private repo such as ECR, Artifact Repository we need to provide our necessary credentials in the Jenkinsifle since our server needs to be login into the private registries.
    
-   Tag and Push it to your Repo ( Github, Bitbucket, ECR ... etc)

-   Create a Jenkinsfile

    ``` NOTE: You can create scripts for building , tagging and deploying you app to K8s environmet ```

-   In the Jenkinsfile, Since there will be some stages you should use pipeline. 

        In order to authenticate your Jenkins server with some privilages you need to define some variables and Dynamic Block.

        In this configuration we wanted to deploy our app in the AWS and we need to define some necessary variables like ECR_REPO, APP_NAME, AWS_REGION.. etc

 -  As a post build  action we wanted to delete all the local images so we need to define it in the post section in the Jenkinsfile

 - We use helm charts to deploy that application into the environment.

 -  In the hlem charts we have created deployment and service files and we used NodePort type servivce for the reason of seeing our application from everywhere.








