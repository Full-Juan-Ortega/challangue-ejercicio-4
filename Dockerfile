
# Imagen basada en jenkins + terraform + aws cli
FROM jenkins/jenkins:lts

USER root
#copiar al usuario de jenkins ( este paso quedo opcional dado que termine usando archivos de github para deployar )
COPY ./terraform /home/jenkins/terraform
COPY ./kubernetes /home/jenkins/kuber
# Actualizar y preparar el sistema para la instalación de Terraform
RUN apt update && \
    apt install -y wget gnupg lsb-release software-properties-common && \
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --yes && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt update && apt install -y terraform

# Instalar AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Cambiar de vuelta al usuario de Jenkins
USER jenkins

