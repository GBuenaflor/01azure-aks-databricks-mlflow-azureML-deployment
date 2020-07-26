----------------------------------------------------------
# Azure Kubernetes Services (AKS) - Azure Databricks, MLFlow and Azure Machine Learning deployment
 
# High Level Architecture Diagram:


![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks01.png)


# Configuration Flow :

------------------------------------------------------------------------------
Prerequisite : Provision Azure Environment using Azure Terraform

1.  View Machine learning Library that can be use, select diabetes dataset from SKLearn.

2.  Create a Azure DataBricks Cluster, install required library and upload a notebook

3.  Run the notebook, to create an Azure ML Workspace and build container image for model deployment

4.  Deploy model image to aci (staging/dev) or to aks (production)


------------------------------------------------------------------------------
# Prerequisite : Provision Azure Environment using Azure Terraform

 
terraform init

terraform plan

terraform apply


Note : AKS and Azure Databricks will be created, other services will be created by the Notebook
 
