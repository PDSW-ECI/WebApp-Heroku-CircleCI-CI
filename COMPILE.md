# Compilación continua

Para compilar de forma continua con maven utilice el script `compile.sh`.
Agregue el privilegio de ejecución al script:
```
chmod +x compile.sh
```

Y utilicelo de la siguiente manera:
```bash
./compile.sh
```

Para actualizar una aplicacion que se ejecuta con tomcat 7, agregue en el `pom.xml` en la seccion de configuración
del `tomcat7-maven-plugin`:

```xml
<contextReloadable>true</contextReloadable>
```


