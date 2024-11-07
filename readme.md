# Caso 4  
- Pipeline para el despliegue de IaC de Terraform via Jenkins  
Vamos a necesitar un pipeline que despliegue IaC que anteriormente habiamos importado (Caso 2) utilizando Jenkins. Ademas de los recursos anteriores, tambien vamos a necesitar son los siguientes.  
- IAM Role con permisos para acceder a la vpc-node-app, permisos para acceder al bucket de s3 node-app-backup
- S3 con versionamiento llamado con el prefix: node-app-logs-*
NOTA: Este pipeline debera utilizar el state remoto del Caso 2  

## dependencias : 
- Instale terraform segun la doc oficial :  
<https://developer.hashicorp.com/terraform/install?product_intent=terraform#linux>  


### Levantar el pod de jenkins publicamente.
exponer jenkins publicamente en el puerto 30000 :  
kubectl port-forward svc/jenkins 30000:30000 --address 0.0.0.0 &  

datos de jenkins : 
url : http://44.210.52.58:30000/  
user : juan  
password : 1234  

### conseguir los archivos de tf del caso 2.  
Hice un repositorio nuevo 

<https://github.com/Full-Juan-Ortega/challangue-ejercicio-4>  

Para esto aprendi a usar la auth via ssh de git.  

ssh-keygen -t ed25519 -C "juan.ortega.it@gmail.com"
eval "$(ssh-agent -s)"
ssh-add .ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
ssh -T git@github.com

### agregar el iam role y el s3.  
En este paso arme los nuevos archivos tf para los recursos que debo provisionar.  

- S3 bucket node-app-logs-prefix:

Cree el bucket y para los requerimentos adicionales ( versionado y nombre prefix) estuve averiguando en la documentacion oficial.  

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket>  

Para manejar el versionado cree un recurso adicional del tipo aws_s3_bucket_versioning  

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning>  

Para verificar que todo este funcionando tal como necesito accedi a las propiedades del bucket

- IAM Role con permisos para acceder a la vpc-node-app, permisos para acceder al bucket de s3 node-app-backup


En este caso cree la politica el ROL y su correspondiente asociacion.

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role>  
<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy> 


- POLICY : Estoy aprendiendo como buscar las policys necesarias para lo que necesito hacer, por otro lado tambien estoy tratando de aprender como testear la policy que estoy haciendo con el AWS simulator.  

arn:aws:ec2:us-west-2:123456789012:vpc/vpc-node-app  
Resource = "arn:aws:ec2:us-west-2:123456789012:vpc/vpc-node-app"   




### jenkins pipeline.




# comandos

`ssh -i "ej-02.pem" ubuntu@ec2-44-210-52-58.compute-1.amazonaws.com`  
kubectl port-forward svc/jenkins 30000:30000 --address 0.0.0.0 &  
kubectl exec -it jenkins-757cdf4c64-8rh8t -- cat /var/jenkins_home/secret
s/initialAdminPassword  


Migrar la carpeta a un nuevo repo.