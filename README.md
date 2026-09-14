# MangaShelf

MangaShelf es una app para llevar tu colección de mangas, hecha para iPhone, iPad y Mac (sí, la misma app corriendo nativa en las tres). La idea es simple: puedes explorar un catálogo de mangas, buscarlos y filtrarlos por género, tema, demografía o autor, y llevar registro de cuáles tienes en tu estantería —cuántos tomos posees, hasta cuál vas leyendo, y si ya la terminaste.

Cuando inicias sesión, tu colección se sincroniza con un backend, así que no se queda guardada solo en tu dispositivo. Y para no tener que abrir la app nada más para ver en qué vas, tiene un widget de pantalla de inicio que muestra tus mangas en progreso. Ah, y está en español e inglés, se adapta automáticamente al idioma del sistema.

Este proyecto está dividido en 4 etapas, cada una marcada con un tag en el repo. La idea era ir subiendo de nivel poco a poco, así que cada tag construye sobre el anterior.

## Los 4 tags

### `v1.0.0-basic`
Aquí nace la app: navegación por tabs, el listado de mangas jalando de la API, la pantalla de detalle de cada manga, y la posibilidad de armar tu colección local (guardada con SwiftData, todavía sin nube). También quedó lista la vista adaptativa.

### `v2.0.0-medium`
Se le suman los filtros completos: género, tema, demografía y autor, cada uno paginado. Básicamente pasa de "aquí está la lista de mangas" a "encuentra justo el manga que buscas".

### `v3.0.0-advanced`
La colección deja de ser solo local: se agrega autenticación (login y registro) y una pantalla de cuenta, y ahora tu colección vive en el backend, sincronizada entre sesiones. También se pulieron los estados vacíos y de error en la lista de colección.

### `v4.0.0-deluxe`
La etapa final. Se agregó soporte nativo para macOS (la misma app, ventana y todo), el widget de pantalla de inicio en iOS y iPadOS con deep link directo a cada item de tu colección, localización completa en español e inglés, y bastante pulido general: ícono de la app, ratings con estrellas, mejor manejo de la sesión, y varios fixes de UI a lo largo del camino.

## Stack

SwiftUI para toda la interfaz, WidgetKit para el widget, y `async/await` para toda la parte de red contra el backend propio (autenticación, catálogo de mangas y la colección del usuario, que vive en la nube). Todo pensado para correr multiplataforma (iOS, iPadOS y macOS) desde una sola base de código.
