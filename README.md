# ucevaflutter

# Taller Flutter – Navegación, Widgets y Ciclo de Vida

Este proyecto implementa un conjunto de requisitos para aprender **navegación con GoRouter**, uso de **widgets avanzados** y **registro del ciclo de vida de los widgets en Flutter**.

---

## Caracteristicas

### 1. Navegación y paso de parámetros
- Se configuró **GoRouter** como gestor de navegación.
- Se implementó:
  - **go** → reemplaza la pila de navegación.
  - **push** → añade una nueva pantalla a la pila.
  - **replace** → reemplaza la ruta actual.
  - **pushReplacement** → quita la ruta actual y la reemplaza.
- El parámetro `method` se pasa como parte de la URL (`/details?method=go`) y se muestra en la pantalla `DetailsScreen`.

### 2. Implementación de widgets
- **GridView**: muestra una lista de 4 ítems, cada uno usando un método diferente de navegación (`go`, `push`, `replace`, `pushReplacement`).
- **TabBar**: organiza la aplicación en tres pestañas:
  1. GridView de navegación.
  2. `ParamSenderTab`: contiene un **TextField** para enviar parámetros.
  3. Vista receptora que muestra el parámetro enviado.
- **TextField**: usado para capturar texto y enviarlo como parámetro a otra pestaña.

### 3. Ciclo de vida de widgets
En `DetailsScreenState` se registran en consola:
- `initState()` → cuando el widget se inicializa.
- `didChangeDependencies()` → cuando cambian dependencias como el tema.
- `build()` → cada vez que se construye la UI.
- `setState()` → al modificar el estado.
