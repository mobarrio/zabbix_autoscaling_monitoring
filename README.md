Openshift Auto Scaling Activity - Add or Remove Nodes to Zabbix Server
=============

## Description
Estos scripts y templates nos permiten monitorizar nodos dinamicamente y eliminarlos de la monitorizacion cuando ya no son necesarios ya. De esta forma la actividad de autoescalado de y monitorizacion es dinamica y de la misma forma podemos eliminar los hosts que dejan de estar activos.

## Features
1. Registro y monitorizacion automatica de nodos 
Mediante las acciones de Autoregistracion podemos crear los nuevos nodos automaticamente para poder ser monitorizados por Zabbix.

2. Baja automatica de nodos
Cuando los nodos dejan de estar disponibles, automaticamente son eliminados de Zabbix via API.

## Installation
1. Ponemos el archivo zbxapi.sh en el directorio de External scripts del Zabbix Server. [external_checks_scripts](https://github.com/tsubauaaa/zabbix_aws_integration/tree/master/external_checks_scripts).

2. Importamos el Template en nuestro Zabbix Server. [template](https://github.com/tsubauaaa/zabbix_aws_integration/blob/master/templates/Template_AWS_Integration.xml).
   1. Ajustamos la MACRO de template {$ZBXSERVER} apuntandola a la IP de nuestro Zabbix Server.

3. Creamos una accion de Auto Registracion para los nuevos nodos.
4. Creamos una accion de Trigger para la eliminacion de los hosts.
![Imgur](https://i.imgur.com/dy07x38l.png)
![Imgur](https://i.imgur.com/ax6VA3Gl.png)
![Imgur](https://i.imgur.com/xxKGmL6l.png)
![Imgur](https://i.imgur.com/fQNjf94l.png)
![Imgur](https://i.imgur.com/lXFePHtl.png)
![Imgur](https://i.imgur.com/u7AOQJZl.png)
![Imgur](https://i.imgur.com/rQrtB1Gl.png)

## License
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

## Author
[mobarrio](https://github.com/mobarrio)
