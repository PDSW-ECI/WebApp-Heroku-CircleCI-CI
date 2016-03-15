##Integración contínua con CircleCI y Heroku

[Documentación CircleCI para Heroku:](https://circleci.com/docs/continuous-deployment-with-heroku)

###Parte I.

1. Retome el proyecto Web desarrollado en el laboratorio antepasado (la herramientade registro de consultas a pacientes), e integre en el mismo el esquema de DAOs del laboratorio pasado. Recuerde que además de los fuentes, debe incorporar las dependencias y demás 'plugins' que se estén usando en el POM.xml de este último.

2. Haga una nueva implementación de la interfaz "ServiciosPacientes", pero que a diferencia de la disponible actualmente (ServiciosPacientesStub), maneje un esquema de persistencia real, a través del esquema de DAOs implementado.

3. Actualice los cambios realizados en su repositorio de GitHUB.

###Parte II.

1. Cree (si no la tiene aún) una cuenta en el proveedor PAAS Heroku ([www.heroku.com](www.heroku.com)).
2. Acceda a su cuenta en Heroku y cree una nueva aplicación:

	![](img/HerokuCreateApp.png)

3. Después de crear su cuenta en Heroku y la respectiva aplicación, genere una llave de API: Opción Manage Account:

	![](img/ManageAccount.png)
	
	Opción API Key:
	![](img/GenerateKey.png)

4. Ingrese a la plataforma de integración contínua Circle.CI ([www.circleci.com](www.circleci.com)). Para ingresar, basta que se autentique con su usuario de GitHUB.

5. Ingrese a las opciones generales de su cuenta y registre la llave de Heroku. Con esto, CircleCI tendrá privilegios para hacer despliegue automático.

	![](img/AccountSettings.png)
	![](img/AddKey.png)

6. Conecte su aplicación (la desarrollada en la parte I) con el ambiente de integración contínua. Abra la opción de 'agregar proyecto':

	![](img/ConnectProject.png)
	
	Seleccione el proyecto de la parte I, y seleccione 'build project'.
	
	![](img/AddProjects.png)

	
7. En CircleCI, seleccione el proyecto recién agregado, abra su menú de opciones y seleccione las opciones de despliegue de Heroku:

	![](img/ProjectSettings.png)
	![](img/HerokuDeployment.png)

	Verifique que ya esté registrada la llave del API. Luego, asocie el 'usuario de despliegue' (Step 2):

	![](img/SetDeployUser.png)

8. Si todo queda correctamente configurado, cada vez que hagan un PUSH al repositorio, CircleCI ejecutará la fase de construcción del proyecto. Para que cuando las pruebas pasen automáticamente se despliegue en Heroku, deben definir en el archivo circle.yml (ubicado en la raíz del proyecto):
	* La rama del repositorio de GitHUB que se desplegará en Heroku. o El nombre de la aplicación de Heroku en la que se hará el
despliegue.
	* La ejecución de la fase ‘site’ de Maven, para generar la
documentación de pruebas, cubrimiento de pruebas y análisis estático (cuando las mismas sean habilitadas).

	Ejemplo:
	[https://github.com/PDSW-ECI/base-proyectos/blob/master/circle.yml](https://github.com/PDSW-ECI/base-proyectos/blob/master/circle.yml)

9. Heroku requiere los siguientes archivos de configuración (con sus respectivos contenidos) en el directorio raíz del proyecto, de manera que sea qué versión de Java utilizar, y cómo iniciar la aplicación, respectivamente:

	system.properties

	```
java.runtime.version=1.8
```

	Procfile

	```
web: java -Dserver.port=$PORT -jar target/*.jar
```

10. El ambiente de despliegue contínuo requiere también un archivo de configuración 'circle.yml' en la raíz del proyecto, en el cual se indica (entre otras cosas) en qué aplicación de Heroku se debe desplegar la aplicación que está en GitHUB. Puede basarse en el siguiente archivo, teniendo en cuenta que se debe ajustar el parámetro 'appname': [https://github.com/PDSW-ECI/base-proyectos/blob/master/circle.yml](https://github.com/PDSW-ECI/base-proyectos/blob/master/circle.yml)


6. Haga commit y push de su repositorio local a GitHub. Abra la consola de CircleCI y verifique que el de descarga, compilación, y despliegue. Igualmente, verifique que la aplicación haya sido desplegada en Heroku.

