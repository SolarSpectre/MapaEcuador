# 🗺️ Mapa de Provincias del Ecuador - Aplicación Docker

Una aplicación web moderna que muestra un mapa interactivo del Ecuador con información detallada sobre las 24 provincias, incluyendo capitales, áreas, poblaciones y coordenadas geográficas. Construida con Flask, MySQL y Nginx como balanceador de carga.

## 🏗️ Arquitectura

La aplicación consta de 4 componentes principales:

- **2 Aplicaciones Flask**: Aplicaciones Flask idénticas que sirven el mismo contenido para balanceo de carga
- **Base de Datos MySQL**: Almacena información de las provincias con las 24 provincias del Ecuador
- **Nginx Balanceador de Carga**: Distribuye el tráfico entre las dos aplicaciones Flask
- **Docker Compose**: Orquesta todos los servicios

```
┌─────────────────┐    ┌─────────────────┐
│   Nginx (LB)    │    │   Flask App 1   │
│   Puerto 80     │◄──►│   Puerto 5000   │
└─────────────────┘    └─────────────────┘
         │                       │
         │              ┌─────────────────┐
         └─────────────►│   Flask App 2   │
                        │   Puerto 5000   │
                        └─────────────────┘
                                │
                        ┌─────────────────┐
                        │   MySQL DB      │
                        │   Puerto 3306   │
                        └─────────────────┘
```

## 🚀 Características

- **Mapa Interactivo de Google Maps**: Muestra el Ecuador con marcadores de provincias
- **Información de Provincias**: Capital, área, población y datos de región
- **Funcionalidad de Búsqueda**: Buscar provincias por nombre o capital
- **Diseño Responsivo**: Funciona en dispositivos de escritorio y móviles
- **Balanceo de Carga**: Tráfico distribuido entre dos instancias Flask
- **Estadísticas en Tiempo Real**: Resumen de la demografía del Ecuador
- **Interfaz Moderna**: Interfaz hermosa e intuitiva con animaciones suaves
- **Estadísticas Generales**: Resumen de provincias, población total, área total y regiones

## 📋 Prerrequisitos

- Docker y Docker Compose instalados
- Clave API de Google Maps (nivel gratuito disponible)

## 🛠️ Instrucciones de Configuración

### 1. Clonar y Navegar
```bash
cd MapaEcuador
```

### 2. Configurar Variables de Entorno
Crear un archivo `.env` en el directorio raíz:
```bash
# Crear archivo .env
echo "GOOGLE_MAPS_API_KEY=tu_clave_api_de_google_maps_aqui" > .env
```

**Para obtener una clave API de Google Maps:**
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la "Maps JavaScript API"
4. Crea credenciales (clave API)
5. Reemplaza `tu_clave_api_de_google_maps_aqui` con tu clave API real

### 3. Construir e Iniciar Servicios
```bash
# Construir e iniciar todos los servicios
docker-compose up --build -d

# O iniciar sin modo detached para ver logs
docker-compose up --build
```

### 4. Acceder a la Aplicación
- **Aplicación Principal**: http://localhost
- **Base de Datos**: localhost:3306 (usuario: ecuador_user, contraseña: ecuador_pass)

## 📊 Esquema de Base de Datos

La base de datos MySQL contiene una tabla `provinces` con la siguiente estructura:

```sql
CREATE TABLE provinces (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capital VARCHAR(100) NOT NULL,
    area_km2 DECIMAL(10,2) NOT NULL,
    population INT NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    region VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Las 24 Provincias del Ecuador Incluidas:

**Región Sierra (Andes):**
- Azuay, Bolívar, Cañar, Carchi, Cotopaxi, Chimborazo, Imbabura, Loja, Pichincha, Tungurahua

**Región Costa:**
- El Oro, Esmeraldas, Guayas, Los Ríos, Manabí, Santa Elena, Santo Domingo de los Tsáchilas

**Región Amazonía:**
- Morona Santiago, Napo, Orellana, Pastaza, Sucumbíos, Zamora Chinchipe

**Región Galápagos:**
- Galápagos

## 🔧 Endpoints de API

### Obtener Todas las Provincias
```http
GET /api/provinces
```

### Obtener Provincia Específica
```http
GET /api/province/{id}
```

### Verificación de Salud
```http
GET /api/health
```

## 🐳 Comandos de Docker

### Iniciar Servicios
```bash
docker-compose up -d
```

### Detener Servicios
```bash
docker-compose down
```

### Ver Logs
```bash
# Todos los servicios
docker-compose logs

# Servicio específico
docker-compose logs flask_app1
docker-compose logs nginx
docker-compose logs mysql
```

### Reconstruir Servicios
```bash
docker-compose up --build -d
```

### Acceder a Shell del Contenedor
```bash
# Aplicación Flask
docker-compose exec flask_app1 bash

# Base de datos
docker-compose exec mysql mysql -u ecuador_user -p ecuador_db

# Nginx
docker-compose exec nginx sh
```

## 📁 Estructura del Proyecto

```
Tarea/
├── docker-compose.yml          # Archivo principal de orquestación
├── .env                        # Variables de entorno (crear este archivo)
├── README.md                   # Este archivo
├── flask_app/
│   ├── Dockerfile             # Contenedor de la aplicación Flask
│   ├── requirements.txt       # Dependencias de Python
│   ├── app.py                 # Aplicación principal Flask
│   └── templates/
│       └── index.html         # Interfaz web
├── database/
│   └── init.sql               # Inicialización de la base de datos
└── nginx/
    └── nginx.conf             # Configuración de Nginx
```

## 🔍 Monitoreo y Depuración

### Verificar Estado de Servicios
```bash
docker-compose ps
```

### Monitorear Uso de Recursos
```bash
docker stats
```

### Prueba de Conexión a Base de Datos
```bash
docker-compose exec mysql mysql -u ecuador_user -p ecuador_db -e "SELECT COUNT(*) FROM provinces;"
```

### Prueba de Balanceador de Carga
```bash
# Probar múltiples solicitudes para ver el balanceo de carga
for i in {1..10}; do curl -s http://localhost/api/health; echo; done
```

## 🚨 Solución de Problemas

### Problemas Comunes

1. **Google Maps no carga**
   - Verificar si la clave API está configurada correctamente en `.env`
   - Verificar que la clave API tenga habilitada la Maps JavaScript API

2. **Errores de conexión a la base de datos**
   - Esperar a que MySQL inicie completamente (puede tomar 30-60 segundos)
   - Revisar logs: `docker-compose logs mysql`

3. **Conflictos de puertos**
   - Asegurar que los puertos 80, 3306 no estén en uso
   - Cambiar puertos en `docker-compose.yml` si es necesario

4. **Las aplicaciones Flask no responden**
   - Verificar si la base de datos está lista: `docker-compose logs flask_app1`
   - Verificar que las variables de entorno estén configuradas

### Reiniciar Todo
```bash
# Detener y eliminar todo
docker-compose down -v

# Eliminar todas las imágenes
docker system prune -a

# Reconstruir desde cero
docker-compose up --build -d
```