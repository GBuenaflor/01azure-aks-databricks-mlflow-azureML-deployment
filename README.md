----------------------------------------------------------
# Azure Kubernetes Services (AKS) - Part 05
# Deploy and Serve Model using Azure Databricks, MLFlow and Azure ML deployment to ACI or AKS
 
 
High Level Architecture Diagram:


![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks01.png)


Configuration Flow :

------------------------------------------------------------------------------
Prerequisite : Provision Azure Environment using Azure Terraform

1.  View Machine learning Library that can be use, select diabetes dataset from SKLearn.

2.  Create a Azure DataBricks Cluster, install required library and upload a notebook

3.  Run the notebook, to create an Azure ML Workspace and build container image for model deployment

4.  Attach Azure Machine Learning to exisiting AKS Cluster and deploy the model image


------------------------------------------------------------------------------
# Prerequisite : Provision Azure Environment using Azure Terraform

 
terraform init

terraform plan

terraform apply


Note : AKS and Azure Databricks will be created, other services will be created by the Notebook
 
 
------------------------------------------------------------------------------
#  1.  View Machine learning Library that can be use, in this post, select diabetes dataset from Scikit-learn.


https://scikit-learn.org/stable/auto_examples/index.html

https://scikit-learn.org/stable/auto_examples/exercises/plot_cv_diabetes.html#sphx-glr-auto-examples-exercises-plot-cv-diabetes-py


Make a query in the dataset. We will train a model using this data.


![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks02.png)



------------------------------------------------------------------------------
#  2.  Create a Azure DataBricks Cluster, install required libraries and upload the notebook


Using the Auzre Portal, create a new Azure Databricks Cluster


![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks03.png)


Then install the required libraries.


![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks04.png)



Note : 


    In Staging / Development  
	
	
	cluster_purpose = AksCompute.ClusterPurpose.DEV_TEST

	
    In Production  
  
    
	At least 3 machine(s) are required for cluster with purpose 'FastProd'
	In this post I only use 2 cluster to save money.


------------------------------------------------------------------------------
#  3.  Run the notebook, to create an Azure ML Workspace, train the model, and build container image for model deployment



![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks05.png)
 


------------------------------------------------------------------------------
#  4.  Attach Azure Machine Learning to existing AKS Cluster and deploy the model image

  

![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks06.png)
 
 
 
 
 
Note : 


    In Staging / Development  use ACI
		
		
    In Production use AKS
	
	
	Option 1: Create new AKS Cluster  
	
    Option 2: existing AKS Cluster 
	
     

------------------------------------------------------------------------------

#  To implement Ingress controller:
   
   
NGINX-Ingress Controller:
https://github.com/GBuenaflor/01azure-aks-ingresscontroller-https




Appplication Gateway Ingress Controller:
https://github.com/GBuenaflor/01azure-aks-ingresscontroller-agic




<br>
<br>
<br>

Note: My Favorite > Microsoft Technologies.

