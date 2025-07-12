# 🗺️ Ecuador Provinces Map - Docker Application

A modern web application that displays an interactive map of Ecuador with detailed information about all 24 provinces, including capitals, areas, populations, and geographical coordinates. Built with Flask, MySQL, and Nginx load balancer.

## 🏗️ Architecture

The application consists of 4 main components:

- **2 Flask Web Applications**: Identical Flask apps serving the same content for load balancing
- **MySQL Database**: Stores province information with 24 provinces of Ecuador
- **Nginx Load Balancer**: Distributes traffic between the two Flask applications
- **Docker Compose**: Orchestrates all services

```
┌─────────────────┐    ┌─────────────────┐
│   Nginx (LB)    │    │   Flask App 1   │
│   Port 80       │◄──►│   Port 5000     │
└─────────────────┘    └─────────────────┘
         │                       │
         │              ┌─────────────────┐
         └─────────────►│   Flask App 2   │
                        │   Port 5000     │
                        └─────────────────┘
                                │
                        ┌─────────────────┐
                        │   MySQL DB      │
                        │   Port 3306     │
                        └─────────────────┘
```

## 🚀 Features

- **Interactive Google Maps**: Display Ecuador with province markers
- **Province Information**: Capital, area, population, and region data
- **Search Functionality**: Search provinces by name or capital
- **Responsive Design**: Works on desktop and mobile devices
- **Load Balancing**: Traffic distributed between two Flask instances
- **Real-time Statistics**: Overview of Ecuador's demographics
- **Modern UI**: Beautiful, intuitive interface with smooth animations

## 📋 Prerequisites

- Docker and Docker Compose installed
- Google Maps API key (free tier available)

## 🛠️ Setup Instructions

### 1. Clone and Navigate
```bash
cd Tarea
```

### 2. Set Environment Variables
Create a `.env` file in the root directory:
```bash
# Create .env file
echo "GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here" > .env
```

**To get a Google Maps API key:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the "Maps JavaScript API"
4. Create credentials (API key)
5. Replace `your_google_maps_api_key_here` with your actual API key

### 3. Build and Start Services
```bash
# Build and start all services
docker-compose up --build -d

# Or start without detached mode to see logs
docker-compose up --build
```

### 4. Access the Application
- **Main Application**: http://localhost
- **Database**: localhost:3306 (user: ecuador_user, password: ecuador_pass)
- **Nginx Status**: http://localhost:8080/nginx_status

## 📊 Database Schema

The MySQL database contains a `provinces` table with the following structure:

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

### Ecuador's 24 Provinces Included:

**Sierra (Highlands) Region:**
- Azuay, Bolívar, Cañar, Carchi, Cotopaxi, Chimborazo, Imbabura, Loja, Pichincha, Tungurahua

**Costa (Coast) Region:**
- El Oro, Esmeraldas, Guayas, Los Ríos, Manabí, Santa Elena, Santo Domingo de los Tsáchilas

**Amazonía (Amazon) Region:**
- Morona Santiago, Napo, Orellana, Pastaza, Sucumbíos, Zamora Chinchipe

**Galápagos Region:**
- Galápagos

## 🔧 API Endpoints

### Get All Provinces
```http
GET /api/provinces
```

### Get Specific Province
```http
GET /api/province/{id}
```

### Health Check
```http
GET /api/health
```

## 🐳 Docker Commands

### Start Services
```bash
docker-compose up -d
```

### Stop Services
```bash
docker-compose down
```

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs flask_app1
docker-compose logs nginx
docker-compose logs mysql
```

### Rebuild Services
```bash
docker-compose up --build -d
```

### Access Container Shell
```bash
# Flask app
docker-compose exec flask_app1 bash

# Database
docker-compose exec mysql mysql -u ecuador_user -p ecuador_db

# Nginx
docker-compose exec nginx sh
```

## 📁 Project Structure

```
Tarea/
├── docker-compose.yml          # Main orchestration file
├── .env                        # Environment variables (create this)
├── README.md                   # This file
├── flask_app/
│   ├── Dockerfile             # Flask app container
│   ├── requirements.txt       # Python dependencies
│   ├── app.py                 # Main Flask application
│   └── templates/
│       └── index.html         # Web interface
├── database/
│   └── init.sql               # Database initialization
└── nginx/
    └── nginx.conf             # Nginx configuration
```

## 🔍 Monitoring and Debugging

### Check Service Status
```bash
docker-compose ps
```

### Monitor Resource Usage
```bash
docker stats
```

### Database Connection Test
```bash
docker-compose exec mysql mysql -u ecuador_user -p ecuador_db -e "SELECT COUNT(*) FROM provinces;"
```

### Load Balancer Test
```bash
# Test multiple requests to see load balancing
for i in {1..10}; do curl -s http://localhost/api/health; echo; done
```

## 🚨 Troubleshooting

### Common Issues

1. **Google Maps not loading**
   - Check if API key is set correctly in `.env`
   - Verify API key has Maps JavaScript API enabled

2. **Database connection errors**
   - Wait for MySQL to fully start (may take 30-60 seconds)
   - Check logs: `docker-compose logs mysql`

3. **Port conflicts**
   - Ensure ports 80, 3306 are not in use
   - Change ports in `docker-compose.yml` if needed

4. **Flask apps not responding**
   - Check if database is ready: `docker-compose logs flask_app1`
   - Verify environment variables are set

### Reset Everything
```bash
# Stop and remove everything
docker-compose down -v

# Remove all images
docker system prune -a

# Rebuild from scratch
docker-compose up --build -d
```

## 📈 Performance Features

- **Load Balancing**: Round-robin distribution between Flask apps
- **Rate Limiting**: API endpoints protected against abuse
- **Gzip Compression**: Reduced bandwidth usage
- **Caching Headers**: Optimized static file delivery
- **Health Checks**: Automatic failover for unhealthy instances

## 🔒 Security Features

- **Security Headers**: XSS protection, content type validation
- **Rate Limiting**: Prevents API abuse
- **CORS Configuration**: Proper cross-origin handling
- **Input Validation**: SQL injection prevention
- **Environment Variables**: Secure configuration management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `docker-compose up --build`
5. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Data sourced from official Ecuador government statistics
- Google Maps API for mapping functionality
- Flask and Nginx communities for excellent documentation 