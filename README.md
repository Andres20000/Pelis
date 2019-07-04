# Pelis

Algunas Aclaraciones


* Usé Xcode 10.1 y  Cocoapods, si van a correr el proyecto recordar abrir el .xcworkspace
* Usé las librerias:   Alamofire para el consumo del API del películas. Disk para facilitar la persistencia de los Datos. SDWebImage para la descarga y cache de la imágenes. 
* La estrategia es en general: Si la app tiene acceso a Internet siempre descarga de TMdB y salva toda la info. Si no hay internet recurre a lo que hay en disco.
* La opción de búsqueda intenta primero hacer la búsqueda Online, de lo contrario busca local. 
* No encontré ninguna película con video en Vimeo, ese pedazo esta sin probar. 
* El modelo de datos de la app quedó “amarrado” a la estructura de datos de  TMdB. Eso facilitó algunos aspectos, pero soy consiente que limita la escalabilidad de la  app, por ejemplo, sí se quisiera tener varias fuentes de datos.  El problema no mencionaba nada respecto a cosas así y preferí ser pragmático.  



1. Capas de la aplicación: 

En general como  la mayoría las  aplicaciones iOS sigue el patrón Modelo-Vista-Controlador, aunque cuando se necesita se  puede extender y agregarle agregarle algún ViewModel o capa adicional como se uso para el caso de las listas de películas por categorías. 

* Una capa que llamo “El Modelo” que su función básica es definir la estructura de datos y en este caso, que el tamaño de la app es pequeño, se encarga de hacer manejar la lógica de negocio, de la carga de la información de las películas y su persistencia. Acá se encuentran las siguientes clases:

Modelo:  Este es el corazón de esta app, maneja toda la lógica de descarga, de persistencia y provee los métodos necesarios para el acceso a la info de los controladores. (Sigue el patrón singleton) 
Pelicula:  Define la estructura de una película es sus aspectos básicos.
PeliculaDetalle: Define la estructura de una película en detalle.
Video: Define la estructura de datos que se necesitan para visualizar un video
Crew :  Define la estructura de datos de un miembro del equipo que realizó la película. 
ResumenTitulos:  Esta estructura sirve para las búsquedas locales. Cada vez que se ve el detalle de una película, se almacena en un arreglo con elementos de este tipo, el id y el titulo de la película. Cuando se esta offline, se acude a esta estructura para hacer las búsquedas. Por ahora solo hace búsquedas por palabras en el titulo pero se podría extender fácil a otros elementos. 
MDBConfiguracion: Define información básica que provee TMdB, en este caso las url de los  tamaños de las imágenes. 
MDBConfiguracionBase:   Estructura utilitaria necesario para descargar MDBConfiguracion
PagedCategoryResponse:  Esta estructura modela  las solicitudes al API de una lista de películas.  

* La capa de Controladores, que son todos los UIViewControllers, TableViewControllers etc. 

PeliculasVC:  Despliega una lista  de películas. En principio podrían ser miles.  
CeldaPelicula: Son las Celdas usadas por  PeliculasVC, para pintar cada película.
BuscarPeliculasTableViewController: Permite hacer búsquedas online/offline de peliculas
DetallePeliculaViewController: Despliega el detalle de un película y controla la forma reproducir un video (YouTube/Vimeo)
YouTubeVC: Reproduce un video de Youtube usando un webview. 

* La capa ViewModel que cuando se necesite se puede usar para descargar de trabajo al controlador

PeliculasViewModel:  Se encarga de llevar el control de la “paginación” y descarga de la información de las películas en apoyo al controlador   PeliculasVC

* La capa de la Vista que es el storyboard. 



2.  En qué consiste el principio de responsabilidad única? Propósito?

Este principio promueve que cada clase y hasta cada capa, no haga  ni más ni menos de lo que debe hacer. Ademas  promueve las relaciones entre las objetos/capas que deben estar juntos y separa a los que no deben estar relacionados.  El propósito es tener un código más fácil de  extender  y mantener.  Pero también podría terminar con clases o modulos más reutilizables.

3. Qué características tiene según  su opinión un código bueno o limpio?

Para mí un código bueno lo primero que tiene que tener  es que en general funcione, que use patrones de diseño siempre que aplique, que las responsabilidades de cada capa propuesta se respeten. Si a lo anterior se le suma pocas lineas de código por cada método y buenas practicas de edición mejor aun.  
