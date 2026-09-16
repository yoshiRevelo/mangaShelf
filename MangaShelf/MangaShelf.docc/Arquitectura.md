# Arquitectura

Cómo está organizado el proyecto por dentro y por qué.

## Overview

Esta app necesitaba hablar con una API externa, guardar
la sesión del usuario, sincronizar su colección en la nube, y encima correr
igual de bien en iPhone, iPad y Mac. Para que tuviera una buena estructura,
armé el proyecto en capas bien separadas, cada una con una sola
responsabilidad.

![Arquitectura de la app](architecture.png)

### App

Aquí vive el punto de entrada (`MangaShelfApp`), el `AppRouter` que controla
la navegación entre tabs, y `AppEnvironment`, que es básicamente la caja de
herramientas que se inyecta a toda la app: los repositorios, el manejador de
sesión, todo lo que cualquier pantalla necesita para funcionar sale de ahí.

### Domain

Los modelos puros: `Manga`, `Author`, `Genre`, `Theme`, `Demographic`,
`CollectionItem`. Son structs simples, sin lógica de red ni de persistencia
metida adentro; no les importa de dónde vienen los datos, 
representan la información.

### Core

Todo lo que no es específico de una pantalla. La capa de networking, con un
`Endpoint` que arma cada request (path, método, headers, si necesita auth o
no) y un `NetworkClient` como protocolo para poder poder mockearlo en los tests. Y el
manejo de sesión con `SessionManager`, el cual es un actor que guarda el token en
Keychain y se encarga de refrescarlo solo cuando está por expirar.

### Repositories

Este es el patrón que más me sirvió del proyecto: cada fuente de datos
(mangas, colección, catálogo de filtros, auth) tiene un protocolo, y detrás
una implementación real que habla con la API y una implementación mock. Así,
cuando estoy armando una pantalla en el canvas de SwiftUI Previews, no
dependo de tener internet ni sesión iniciada — uso el mock y listo. La
colección del usuario vive completamente en el backend (no hay persistencia
local); cuando el usuario inicia sesión, todo pasa por `RemoteCollectionRepository`.

### Features

Cada pantalla vive en su propia carpeta con su Screen (la vista) y su
ViewModel (el estado y la lógica). Nada de lógica de negocio metida directo
en la vista — la vista solo pinta lo que el ViewModel le da.

### Design System

Los componentes reutilizables: botones, el layout de flujo para los
tags de género (un `Layout` personalizado), estilos de campos de texto. Para
no repetir el mismo `RoundedRectangle` con los mismos colores en cada
pantalla nueva, implementado como lo vimos durante la formación.

## Sesión y autenticación

El login guarda el token en el Keychain. `SessionManager` es un `actor`, 
así que todo el acceso al token está protegido por diseño.

## El widget

`MangaShelfWidget` es un target aparte que comparte datos con la app
principal a través de un App Group: la app escribe un snapshot de qué mangas
está leyendo el usuario y en qué tomo va (`ReadingSnapshotStore`), y el
widget lo lee de ahí. El widget no le pide nada a la API por su cuenta.

## Multiplataforma

Todo corre desde una sola base de código gracias a `NavigationSplitView`
adaptativo: en iPhone se ve como tabs normales, en iPad aparece el sidebar,
y en Mac es una ventana nativa.

## Localización

La app está en español e inglés usando un String Catalog.
