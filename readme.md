# Caso 4  
- Pipeline para el despliegue de IaC de Terraform via Jenkins  
Vamos a necesitar un pipeline que despliegue IaC que anteriormente habiamos importado (Caso 2) utilizando Jenkins. Ademas de los recursos anteriores, tambien vamos a necesitar son los siguientes.  
- IAM Role con permisos para acceder a la vpc-node-app, permisos para acceder al bucket de s3 node-app-backup
- S3 con versionamiento llamado con el prefix: node-app-logs-*
NOTA: Este pipeline debera utilizar el state remoto del Caso 2  

## dependencias que me faltaban : 
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


## jenkins pipeline.

### Tengo pensado levantar un docker local con jenkins.  
Acceder desde mi local a jenkins :  
* docker run -dti -p 30000:8080 -p 50000:50000 --restart=on-failure -v /home/juan/jenkins_data:/var/jenkins_home jenkins/jenkins:lts-jdk17  

### Config inicial:  
1) cat /var/jenkins_home/secrets/initialAdminPassword  
2) Install sugested pluggins.
datos de jenkins : (saltie)
url : http://44.210.52.58:30000/  
user : juan  
password : 1234  

3) instalar aws credentials y cargar las credenciales.
4) con username&password cargar el usuario y access key de github.

### dependencias necesarias dentro del pod

- terraform

Loguearse como root user.  
docker exec -u root -it $(docker ps -l -q) /bin/bash    
apt update  
apt install -y wget gnupg lsb-release software-properties-common  

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --yes
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs)   main" | tee /etc/apt/sources.list.d/hashicorp.list  
apt update && apt install terraform  


- aws cli  

docker exec -u root -it $(docker ps -l -q) /bin/bash  
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  
unzip awscliv2.zip  
./aws/install  

- instalar plugins de aws credentials.  


### Hacer un pipeline que me devuelva un comentario por consola.
<https://www.jenkins.io/doc/book/pipeline/getting-started/>
1) 
- Hacer un pipeline que haga un pull a un repositorio.
- Hacer un pipeline que se conecte a aws.
- Hacer un pipeline que despliegue el IaC.

Subir el pipeline a github.

### Crear imagen docker con todas las dependencias.

Cree el dockerfile y use los comandos que venia trabajando ya para instalar aws cli y terraform.  
Ademas quiero agregarle los archivos de terraform para luego desplegarlos.

docker build -t jenkins-with-dependencys .


### Subir la imagen a docker hub.

subir la imagen a dockerhub para despues usarla en la ec2 con minikube.   
esta imagen contiene los archivos tf , de k8 y jenkins.

docker build -t juanortegait/jenkins-with-dependencys:v1 .
docker push juanortegait/jenkins-with-dependencys

<https://hub.docker.com/layers/juanortegait/jenkins-with-dependencys/v1/images/sha256-74b30f1951907ca5368ffd996dacda65dcbbd13f222a9e1291eb59932dec0cbe?context=explore>  

### Desplegar en ec2.

Usar la imagen creada para que el pod de jenkins utilice los archivos que estan dentro de la misma imagen.

- Traer la imagen del registry -> docker pull juanortegait/jenkins-with-dependencys:v1
- modificar el pod kubernetes para que el pod despliegue esa imagen.  
- instalar aws credentials y crear las credenciales en el pod de jenkins.
- crear el job que despliegue el jenkinsfile en el repositorio.


# comandos

`ssh -i "ej-02.pem" ubuntu@ec2-44-210-52-58.compute-1.amazonaws.com`  
kubectl port-forward svc/jenkins 30000:30000 --address 0.0.0.0 &  
kubectl exec -it jenkins-757cdf4c64-8rh8t -- cat /var/jenkins_home/secret
s/initialAdminPassword  


