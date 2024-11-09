# DOCKERFILE PARA PRUEBAS LOCALES.
# Usa la imagen oficial de Jenkins
FROM jenkins/jenkins:lts

# Exponer el puerto interno de Jenkins (8080)
EXPOSE 30000:8080

# Definir un volumen para la persistencia de datos de Jenkins
VOLUME ["/var/jenkins_home"]

CMD ["/bin/bash"]

