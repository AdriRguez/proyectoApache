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

**Configuracion Puertos en el compose**
Añadimos el puerto 8000 y el volumen ConfApache en el docker compose

![Puertos Docker Compose](./Imagenes/compose-puertos.png)

**Creacion ficheros de configuracion desde contenedor**
Fui al contenedor, con el iniciado y le di a Attach en Visual Code, me meti en la carpeta de /var/www/html y puse el comando a2ensite 002-default, pero antes fui al volumen y copie todos los ficheros en la carpeta ConfApache y añadi el puerto con el comando:(Listen 8000) en fichero ports.conf, tambien duplique el fichero de la carpeta "Sites-Available" y despues fue cuando aplique los comandos que mencione antes.
Para terminar la configuracion de los puertos me fui a los sitios default y le cambie el VirtualHost por el indicado del Sitio.

***Configuracion Cliente y DNS en el docker-compose***
Para configurar el Cliente y el DNS tendremos que bajarnos las imagenes del "Alpine y Bind9", despues ponerle ip fija al DNS y ponerle al Cliente que el DNS apunte al Bind9, despues creamos los volumenes de la configuracion del DNS y nos aseguramos de que toda la configuracion este correctamente escrita.
~~~
version: "3.9"
services:
  asir_apache:
      ports:
      - 80:80
      - 8000:8000
      networks:
        bind_subnet:
          ipv4_address: 10.2.0.254
      container_name: asir_apache
      volumes:
      - /home/asir2a/Escritorio/Docker/ProyectoApache/html:/var/www/html
      - ./ConfApache:/etc/apache2
      image: 'php:7.4-apache'
  bind9:
    container_name: asir_bind9
    image: internetsystemsconsortium/bind9:9.16
    ports:
    - 5300:53/udp
    - 5300:53/tcp
    networks:
      bind_subnet:
       ipv4_address: 10.2.0.3
    volumes:
    - /home/asir2a/Escritorio/Docker/ProyectoApache/ConfigDNS/Config:/etc/bind
    - /home/asir2a/Escritorio/Docker/ProyectoApache/ConfigDNS/Zonas:/var/lib/bind
  asir_cliente:
    container_name: asir_cliente
    image: alpine
    networks:
      - bind_subnet
    stdin_open: true
    tty: true
    dns:
      - 10.2.0.3
networks:
  bind_subnet:
    external: true 
~~~

**Configuracion del db.fabulas.com**
Escribiremos el NS para que apunte a la IP del DNS y despues el dominio de oscuras.fabulas.com  a la IP del Servidor Apache, y el CNAME que apunte a oscuras.fabulas.com
~~~
$TTL    3600   
@       IN      SOA     ns.fabulas.com. adrian.danielcastelao.org. (
                   2022051001           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      ns.fabulas.com.
ns      IN      A       10.2.0.3
oscuras      IN      A       10.2.0.254
maravillosas   IN      CNAME   oscuras
~~~

Despues iniciaremos los contenedores y haremos un attach en el cliente y intentaremos hacer ping a la IP y al dominio.
![Ping desde el cliente al dominio](./Imagenes/PingSitio2.png.png)

Tambien cambiaremos los ficheros de configuracion del sitio "001-default.conf" la parte donde pone "ServerName " y lo descomentaremos y añadiremos el dominio del sitio 1 y 2.
![Configuracion del sitio 1 (Servername)](./Imagenes/Sitio1Servername.png)

