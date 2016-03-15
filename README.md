##Integración contínua con CircleCI y Heroku

[Documentación CircleCI para Heroku:]
(https://circleci.com/docs/continuous-deployment-with-heroku)

A partir de uno de los ejercicios anteriormente desarrollados, va a construir un esquema de despliegue contínuo para el mismo. 


1. Cree una organización en GitHUB para su grupo de trabajo, y en la misma cree un repositorio para el presente ejercicio.

1. Después de crear su cuenta en Heroku y la respectiva aplicación, deben generar una llave de API (opción Manage Account/API Key).
2. Deben ‘conectar’ la aplicación en GitHUB a CircleCI
3. En CircleCI, en las opciones de ‘Project Settings’/Continous
Deployment/Heroku Deployment’, registren la llave de Heroku
4. Si todo queda correctamente configurado, cada vez que hagan un PUSH al repositorio, CircleCI ejecutará la fase de construcción del proyecto. Para que cuando las pruebas pasen automáticamente se despliegue en Heroku, deben definir en el archivo circle.yml (ubicado en la raíz del proyecto):
	* La rama del repositorio de GitHUB que se desplegará en Heroku. o El nombre de la aplicación de Heroku en la que se hará el
despliegue.
	* La ejecución de la fase ‘site’ de Maven, para generar la
documentación de pruebas, cubrimiento de pruebas y análisis estático (cuando las mismas sean habilitadas).

	Ejemplo:
	[https://github.com/PDSW-ECI/base-proyectos/blob/master/circle.yml](https://github.com/PDSW-ECI/base-proyectos/blob/master/circle.yml)

5. Heroku requiere los siguientes archivos de configuración (con sus respectivos contenidos), de manera que sea qué versión de Java utilizar, y cómo iniciar la aplicación, respectivamente:

	system.properties

	```
java.runtime.version=1.8
```

	Procfile

	```
web: java -Dserver.port=$PORT -jar target/*.jar
```

6. Haga commit y push de su repositorio local a GitHub. Abra la consola de CircleCI y verifique que el de descarga, compilación, y despliegue.

7. Para probar la fase de pruebas (aún no implementada), implemente un caso de prueba que siempre falle, teniendo en cuenta las siguientes convenciones:

	* Las pruebas deben estar en la ruta estándar de Maven: src/test/java
	* El nombre de la clase que tiene las pruebas debe terminar en ‘Test’. Por ejemplo, ModuloXXTest.java . Si usan, por ejemplo, el nombre ModuloXXTests.java, la prueba es omitida (esto es un comportamiento poco deseable de Maven, que se da para tener compatibilidad hacia atrás con versiones antiguas de JUnit!!).
	* Los nombres de los métodos en los que se corran las pruebas
también deben terminar en la palabra ‘Test’, por ejemplo:

		```
	@Test
public void registroDePacientesTest(){
...
 }
```

6. Haga commit y push, y verifique que el proceso no haya sido exitoso dada la prueba fallida.
