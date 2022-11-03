# proyecto Apache
Primero creamos el arbol de directorios: ConfApache y despues la carpeta HTML donde vamos a guardar el fichero html y php.

## docker compose
Ahora creamos el docker compose a partir de la imagen de Apache con PHP, a traves de la imagen redactamos el docker-compose.yml.


~~~
"Docker-compose.yml"
version: "3.9"
 services:
  asir_apache:
      ports:
      - 80:80
      container_name: asir_apache
      volumes:
      - /home/asir2a/Escritorio/Docker/ProyectoApache/html:/var/www/html
      - ConfApache:/etc/apache2
      image: 'php:7.4-apache'   
~~~
En el volumen del docker-compose le indicamos la ruta donde vamos a crear el volumen del HTML

## html
Creamos la carpeta y creamos el fichero llamado index.html y le escribimos "Hola Mundo".

### Comprobacion HTML y PHP
Hacemos un docker-compose up y escribimos en el buscador localhost:80 .

**Resultado HTML:**

![Imagen HTML](./Imagenes/html.png)

Y repetimos el proceso creando el fichero info.php y escribimos una funcion en el fichero.

**Resultado PHP:**

![Imagen PHP](./Imagenes/php.png)

