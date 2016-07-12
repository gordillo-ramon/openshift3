# Openshift v3 (3.2)


## Read it first
* [Best Practices building Docker containers]
* [Best Practices building Docker images for Openshift]

## Docker Containers: if you want to change your distribution base to RHEL/CentOS

When we have dockerfiles that are not RHEL/CentOS based, if we want to migrate.


### Change your base image

Example

substitute
`FROM debian:wheezy`
to 
`FROM centos:centos7`

### Change the package manager

Move to "yum" if possible. If not, "rpm" should be used. If the original distribution used apt, it should be analyse the package translation:

```dockerfile
RUN apt-get update && \
	apt-get install -y "gcc" --no-install-recommends \ 
	gcc … && \
	apt-get purge -y --auto-remove "gcc"
```	
We find out that gcc is needed to build the image, so it is installed with apt-get and then removed. Equivalent with CentOS: first we identify which package includes gcc. We execute:

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
From that package, we can use short-name (without version), if there is no both 32 (i686) and 64 bits (x86_64). The above command in CentOS will be:

```dockerfile
RUN yum -y --setopt=tsflags=nodocs install gcc && \
	gcc "…" && \
	yum -y remove gcc \
	yum -y clean all 
```	

#### RHEL 7

If we want to use RHEL instead, we need to know which repository should be enabled before running "yum":

```sh
yum whatprovides gcc

Loaded plugins: langpacks, product-id, search-disabled-repos, subscription-manager
gcc-4.8.2-16.el7.x86_64 : Various compilers (C, C++, Objective-C, Java, ...)
Repo        : rhel-7-server-rpms
```
Then, the dockerfile should include previously:

```dockerfile
RUN yum install -y yum-utils gettext hostname && \
        yum-config-manager --enable rhel-7-server-rpms && \
        yum -y --setopt=tsflags=nodocs install gcc…
```
Which has to be executed from RHEL with docker, otherwise you will not have authorization to enable those repos in the build!

### Applications executed with root or with a named-user

If those applications has some priviledges requirements on some fields/ports, some further changes should be implemented. Those changes will include:
- Grants to files/folders
- Port changes from protected (=<1024) to non-protected (>1024)

## Openshift Templates

### First steps

First, [Openshift Templates] should be read

### Tips & Tricks

* For rapid prototyping, try to use docker hub "official" images if possible.
* Some development templates needs persistent volumes. First, start with ephemeral ones, then add the volumes at a later stage.
* If you need to change the configuration, there are different alternatives.
	* Kubernetes ConfigMaps if you need some config files in a single folder
	* Github volume mount for a whole set of files in a definite structure (for example, plugin jars)
	* Persistent volumes for dev iteration

### Testing

A first test (grammar) can be done with "oc" client. 

```sh
$ oc process -o describe -f template.json 
```

A next test should be instantiating our template, checking that every object is created. Additionally, we need to check:
- Volume mounts are ok
- Pods are starting and running correctly

[Openshift Templates]:https://docs.openshift.com/enterprise/latest/architecture/core_concepts/templates.html
[Best Practices building Docker containers]:https://docs.docker.com/engine/articles/dockerfile_best-practices/
[Best Practices building Docker images for Openshift]:https://docs.openshift.com/enterprise/latest/creating_images/guidelines.html
