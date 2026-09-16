# Memoria

Cómo fue el proceso de construir MangaShelf, de principio a fin.

## Overview

Empecé este proyecto sin tener muy claro qué tan lejos iba a llegar. La
consigna era simple en el papel: consumir una API de mangas, dejar que el
usuario arme su colección, y ya, pero apenas te metes a SwiftUI en serio te
das cuenta de que no es tan fácil como parece. Lo primero que tuve que desbloquear 
era pensar en cómo estructurar la información y llevarla a la realidad 
en distintos dispositivos de Apple.

La primera versión que se encuentra en el tag `v1.0.0-basic`, fue sobre
todo aprender a estructurar todo de una buena forma, separar los modelos de la lógica de red,
entender más a profundidad lo visto durante la formación, repasar y tropezarme e investigar 
para ir aprendiendo y mejorando en cada paso del proyecto.

![v1.0.0](versionBasica.png)

De ahí decidí subir de nivel, lo que se convirtió en el tag `v2.0.0-medium`.
Primero los filtros completos (género, tema, demografía, autor), que me
obligó a pensar bien la paginación y a no duplicar llamadas a la API, ahí
fue cuando entendí por qué vale la pena tener un patrón de repositorio con
su protocolo, su implementación real y un mock, en vez de meter la llamada
de red directo en la vista.

![v2.0.0](versionMedia.png)

Luego vino la parte que más "sube de nivel" se sintió: la nube `v3.0.0-advanced`. Pasar de
guardar la colección en local a manejar login, tokens, y que todo viva en el
backend fue el salto donde más tuve que aprender, sobre concurrencia en
Swift, `actor`, tareas compartidas para no disparar dos refrescos de token
al mismo tiempo, y por supuesto, que las credenciales nunca deben ir en
`UserDefaults` sino en Keychain.

![v3.0.0](versionAvanzada.png)

La etapa deluxe `v4.0.0-deluxe` fue la más entretenida y la más tediosa a la vez. Entretenida
porque ahí metí el widget: que un manga que estás leyendo aparezca en tu pantalla de inicio 
y te lleve a él con un tap se siente como el tipo de detalle que hace que una app 
se sienta terminada. Y porque llevar la misma base de código a macOS nativo, 
sin reescribir nada, confirmó que valió la pena la arquitectura por capas desde 
el principio. Tediosa porque hubo un bug de layout que me costó varios intentos: 
los géneros de algunos mangas (Naruto, por ejemplo, con varios géneros) se 
encimaban con el título de "Sinopsis" cuando necesitaban más de una fila. 
No fue un fix de una sola pasada — tuve que entender cómo SwiftUI mide y 
coloca vistas en dos pasos distintos (`sizeThatFits` y `placeSubviews`) antes de dar con la causa real.
Sinceramente me llevó bastante tiempo, pero es lo que te hace ser más meticuloso y 
aprender realmente como funciona lo que estás creando, es complicado y te das 
muchos topes en el camino, pero una vez que entiendes se siente una gran satisfacción
de saber cómo y por qué, en ese momento sabes que eres un poco mejor aunque siempre
quedan mil cosas por aprender.

![v4.0.0 Widget](versionDeluxe.png)
![macOS](macOS.png)

También localicé toda la app a español e inglés con String Catalogs, lo cual
terminó siendo más meticuloso de lo que esperaba: SwiftUI extrae
automáticamente casi todos los strings de `Text` y `Button`, pero cualquier
string que pasara por una propiedad de tipo `String` en vez de
`LocalizedStringKey` se me escapaba en la primera pasada, y tuve que hacer
una revisión completa, archivo por archivo.

Viendo el proyecto completo ahora, de `v1.0.0-basic` a `v4.0.0-deluxe`, lo
que más rescato es como lo que vimos de principio a fin en la formación lo pude 
materializar en una app multiplataforma, claro que no fue fácil y hubo muchos tropiezos
y frustraciones en el camino, entender, re-entender, modificar en el camino y más.

Para ser sincero no fue sencillo, porque mientras iba avanzando de etapas me iba dando 
cuenta de pequeños bugs que iban apareciendo, entonces el proceso me detenía un poco
al regresar a revisar por qué pasaba tal o cual cosa y cuando más avanzaba y hacía mis test
me daba cuenta de otras cosas, pero finalmente cuando vi el fruto de estos meses de trabajo
me sentí completamente satisfecho.

Para concluir quiero decir que me sentí muy contento del aprendizaje que obtuve y sigo obteniendo,
me entretuve mucho realizando este proyecto y como lo dije al principio, 
me encanta ser desarrollador, ir descubriendo e implementando las funcionalidades
nuevas que Apple nos trae año con año es lo que más disfruto y por supuesto, 
siempre realizarlo de la mejor manera.




