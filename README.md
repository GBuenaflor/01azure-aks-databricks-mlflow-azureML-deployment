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

``` 
terraform init
terraform plan
terraform apply
```

Note : 

AKS and Azure Databricks will be created, other services will be created by the Notebook.

Ensure head room Quota for Compute-VM (cores-vCPUs) subscription limit.
       
------------------------------------------------------------------------------
#  1.  View Machine learning Library that can be use, in this post, select diabetes dataset from Scikit-learn.
         
		
https://scikit-learn.org/stable/auto_examples/index.html

https://scikit-learn.org/stable/auto_examples/exercises/plot_cv_diabetes.html#sphx-glr-auto-examples-exercises-plot-cv-diabetes-py


Make a query in the dataset. We will train a model using this data.

  ``` 
  from sklearn.datasets import load_diabetes

  diabetes = load_diabetes() 
  
  print('diabetes.keys: ', diabetes.keys())
  print('diabetes.data: ', diabetes.data)
  print('diabetes.target: ', diabetes.target)

  ``` 
    
    
    
![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks02.png)



------------------------------------------------------------------------------
#  2.  Create an Azure DataBricks Cluster, install required libraries and upload the notebook


Using the Auzre Portal, create a new Azure Databricks Cluster


![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks03.png)


Then install the required libraries.


![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks04.png)



Note : 
 

    In Staging / Development  
	use cluster_purpose = AksCompute.ClusterPurpose.DEV_TEST

	
    In Production  
	At least 3 machine(s) are required for the cluster with purpose 'FastProd'
	 


------------------------------------------------------------------------------
#  3.  Run the notebook, to create an Azure ML Workspace, train the model, and build container image for model deployment



![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks05.png)
 


------------------------------------------------------------------------------
#  4.  Attach Azure Machine Learning to existing AKS Cluster and deploy the model image


    -In Staging / Development  use ACI		
    -In Production use AKS	
       Option 1: Create a new AKS Cluster  
       Option 2: Connect to an existing AKS cluster   


# Connect to an existing AKS cluster  
  ``` 
from azureml.core.compute import AksCompute, ComputeTarget
 
# Give the cluster a local name
aks_cluster_name = "az-k8s"

# Attach the cluster to your workgroup
attach_config = AksCompute.attach_configuration(resource_group = "Env-DataBricks-RG",
                                                cluster_name = aks_cluster_name,
                                                cluster_purpose = AksCompute.ClusterPurpose.DEV_TEST)  
#  cluster_purpose = AksCompute.ClusterPurpose.DEV_TEST
#  At least 3 machine(s) are required for cluster with purpose 'FastProd'

aks_target = ComputeTarget.attach(workspace=workspace, 
                                  name=aks_cluster_name, 
                                  attach_configuration=attach_config)

aks_target.wait_for_completion(True)

print(aks_target.provisioning_state)
print(aks_target.provisioning_errors)
  
  ``` 
  
  
  # Deploy to the model's image to AKS cluster
  
   ```    
from azureml.core.webservice import Webservice, AksWebservice
from azureml.core import Image

# Set configuration and service name
prod_webservice_name = "diabetes-model-prod"
prod_webservice_deployment_config = AksWebservice.deploy_configuration()
image_name ="model" 
  
  
image = Image(name=image_name, workspace=workspace)


# Deploy from image
prod_webservice = Webservice.deploy_from_image(workspace = workspace, 
                                               name = prod_webservice_name,
                                               image = image, #model_image,
                                               deployment_config = prod_webservice_deployment_config,
                                               deployment_target = aks_target)

   
 ``` 
  
        

![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks06.png)
 
 
 

------------------------------------------------------------------------------
#  Test the Webservice

  
Supply data and view the prediction
  

![Image description](https://github.com/GBuenaflor/01azure-aks-databricks-mlflow-azureML-deployment/blob/master/Images/GB-AKS-DataBricks07.png)
 
  

------------------------------------------------------------------------------


</br>
Link to other Microsoft Azure projects
https://github.com/GBuenaflor/01azure
</br>


Note: My Favorite > Microsoft Technologies.

