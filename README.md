# Openshift v3 (3.1)

## Contenedores Docker

Cuando tenemos Dockerfiles que parten de una distribución que no sea RHEL/CENTOS 7, se deben migrar.

### Documentación previa
* [Best Practices building Docker containers]
* [Best Practices building Docker images for Openshift]

### Cambiar la distro origen.
Debe cambiarse la distro de origen de la que parte el Dockerfile. Ejemplo:

`FROM debian:wheezy`
por 
`FROM centos:centos7`

### Gestión de Paquetes

Revisar y ver la gestión de paquetes. Cambiar de apt-get a yum, y revisar el nombre de los paquetes a instalar. Por ejemplo, si tenemos la siguiente instrucción:

```dockerfile
RUN apt-get update && \
	apt-get install -y "gcc" --no-install-recommends \ 
	gcc … && \
	apt-get purge -y --auto-remove "gcc"
```	
Vemos que se requiere el comando gcc para montar la imagen, y que por eso se descarga el paquete gcc con apt-get y luego se borra. El equivalente en centos, requiere conocer qué paquete trae el comando gcc. Se usa el siguiente comando:

```sh
yum whatprovides gcc

Loaded plugins: fastestmirror, langpacks
Determining fastest mirrors
 * base: centos.cadt.com
 * extras: centos.cadt.com
 * updates: centos.cadt.com
gcc-4.8.3-9.el7.x86_64 : Various compilers (C, C++, Objective-C, Java, ...)
Repo        : base
```
A partir de ahí, podemos usar el nombre largo o el abreviado (antes de la versión) siempre que no haya dos, uno de 32 (i686) y uno de 64 bits (x86_64). Al traducir, ahora sería:

```dockerfile
RUN yum -y --setopt=tsflags=nodocs install gcc && \
	gcc "…" && \
	yum -y remove gcc \
	yum -y clean all 
```	

#### RHEL 7

Si vamos a usar rhel en lugar de centos, es necesario saber cual es el repositorio necesario para habilitar antes de usar el yum para instalar el paquete. Por ejemplo:

```sh
yum whatprovides gcc

Loaded plugins: langpacks, product-id, search-disabled-repos, subscription-manager
gcc-4.8.2-16.el7.x86_64 : Various compilers (C, C++, Objective-C, Java, ...)
Repo        : rhel-7-server-rpms
```
Habría que hacer entonces antes:

```dockerfile
RUN yum install -y yum-utils gettext hostname && \
        yum-config-manager --enable rhel-7-server-rpms && \
        yum -y --setopt=tsflags=nodocs install gcc…
```
Y debe ser ejecutado desde una rhel7 con docker, si no falla la autorización de paquetes!

### Programas que se ejecutan con usuario root

[TO DO]


## Templates de Plantillas

### Documentación previa

Primero, leer [Openshift Templates]

### Trucos

3.1 sólo permite meter parámetros de tipo string. Los parámetros de templates que sean enteros (como los port de los services) a día de hoy tienen que ir a fuego 

### Pruebas

Para probar el template, usar el comando 

```sh
$ oc process -o describe -f template.json 
```

[Openshift Templates]:https://docs.openshift.com/enterprise/latest/architecture/core_concepts/templates.html
[Best Practices building Docker containers]:https://docs.docker.com/engine/articles/dockerfile_best-practices/
[Best Practices building Docker images for Openshift]:https://docs.openshift.com/enterprise/latest/creating_images/guidelines.html
