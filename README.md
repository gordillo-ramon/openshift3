# openshift3

Como hacer templates: 

Primero, leer [Openshift Templates]

3.1 sólo permite meter parámetros de tipo string. Los parámetros de templates que sean enteros (como los port de los services) a día de hoy tienen que ir a fuego 
 
Para probar el template, usar el comando 

```sh
$ oc process -o describe -f template.json 
```

[Openshift Templates]:https://docs.openshift.com/enterprise/latest/architecture/core_concepts/templates.html
