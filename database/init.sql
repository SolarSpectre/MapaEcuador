-- Set character set and collation
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- Create the provinces table
CREATE TABLE IF NOT EXISTS provinces (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    capital VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    area_km2 DECIMAL(10,2) NOT NULL,
    population INT NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    region VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Insert Ecuador's 24 provinces data
INSERT INTO provinces (name, capital, area_km2, population, latitude, longitude, region, description) VALUES
-- Sierra (Highlands) Region
('Azuay', 'Cuenca', 8124.70, 881394, -2.9001, -79.0059, 'Sierra', 'Known for its beautiful colonial architecture and the historic center of Cuenca, a UNESCO World Heritage site.'),
('Bolívar', 'Guaranda', 3945.38, 209933, -1.5926, -79.0000, 'Sierra', 'Famous for its carnival celebrations and the "Pájaro Azul" festival.'),
('Cañar', 'Azogues', 3108.23, 281396, -2.7397, -78.8486, 'Sierra', 'Home to the Ingapirca archaeological site, the largest Inca ruins in Ecuador.'),
('Carchi', 'Tulcán', 3780.45, 186869, 0.8115, -77.7170, 'Sierra', 'Known for its unique cemetery with cypress trees sculpted into various shapes.'),
('Cotopaxi', 'Latacunga', 6091.85, 488716, -0.9333, -78.6167, 'Sierra', 'Named after the Cotopaxi volcano, one of the highest active volcanoes in the world.'),
('Chimborazo', 'Riobamba', 5988.37, 524004, -1.6734, -78.6483, 'Sierra', 'Home to Chimborazo volcano, the point on Earth closest to the sun due to the equatorial bulge.'),
('Imbabura', 'Ibarra', 4612.57, 476257, 0.3517, -78.1223, 'Sierra', 'Known as the "Province of Lakes" due to its numerous lakes and lagoons.'),
('Loja', 'Loja', 11027.87, 521154, -3.9951, -79.2042, 'Sierra', 'Famous for its music and cultural heritage, known as the "Music Capital of Ecuador".'),
('Pichincha', 'Quito', 9692.51, 3228889, -0.2299, -78.5249, 'Sierra', 'Contains the capital city Quito, a UNESCO World Heritage site with rich colonial history.'),
('Tungurahua', 'Ambato', 3334.80, 590600, -1.2491, -78.6167, 'Sierra', 'Known as the "Tierra de los Tres Juanes" and famous for its fruit and flower festival.'),

-- Costa (Coast) Region
('El Oro', 'Machala', 5988.79, 715751, -3.2581, -79.9558, 'Costa', 'Known as the "Banana Capital of the World" and major exporter of bananas and shrimp.'),
('Esmeraldas', 'Esmeraldas', 15039.40, 643654, 1.0283, -79.4635, 'Costa', 'Famous for its beautiful beaches, Afro-Ecuadorian culture, and lush tropical forests.'),
('Guayas', 'Guayaquil', 15603.64, 4440473, -2.1894, -79.8891, 'Costa', 'Contains Guayaquil, Ecuador\'s largest city and main port, known as the "Pearl of the Pacific".'),
('Los Ríos', 'Babahoyo', 7250.27, 921763, -1.8021, -79.5344, 'Costa', 'Known for its extensive river system and agricultural production, especially rice and cocoa.'),
('Manabí', 'Portoviejo', 18893.74, 1567808, -1.0544, -80.4545, 'Costa', 'Famous for its beautiful beaches, fishing industry, and the "Ruta del Spondylus" tourist route.'),
('Santa Elena', 'Santa Elena', 3763.80, 401178, -2.2267, -80.8589, 'Costa', 'Known for its beautiful beaches, fishing villages, and the Salinas resort area.'),

-- Amazonía (Amazon) Region
('Morona Santiago', 'Macas', 23736.97, 196535, -2.3089, -78.1204, 'Amazonía', 'Home to the Shuar indigenous people and the Sangay National Park, a UNESCO World Heritage site.'),
('Napo', 'Tena', 13027.50, 133705, -0.9936, -77.8125, 'Amazonía', 'Known for its Amazon rainforest, indigenous communities, and adventure tourism.'),
('Orellana', 'Francisco de Orellana', 20733.00, 161338, -0.4667, -76.9667, 'Amazonía', 'Contains the Yasuní National Park, one of the most biodiverse places on Earth.'),
('Pastaza', 'Puyo', 29920.42, 114202, -1.4833, -77.9833, 'Amazonía', 'The largest province in Ecuador, known for its vast Amazon rainforest and indigenous cultures.'),
('Sucumbíos', 'Nueva Loja', 18084.42, 230503, 0.0853, -76.8833, 'Amazonía', 'Major oil-producing province, home to the Cuyabeno Wildlife Reserve.'),
('Zamora Chinchipe', 'Zamora', 10584.28, 120416, -4.0667, -78.9500, 'Amazonía', 'Known for its gold mining, indigenous Shuar and Saraguro communities, and the Podocarpus National Park.'),

-- Galápagos Region
('Galápagos', 'Puerto Baquerizo Moreno', 8010.00, 33000, -0.4500, -90.4500, 'Galápagos', 'Famous for its unique wildlife and the Galápagos Islands, a UNESCO World Heritage site and inspiration for Darwin\'s theory of evolution.'),

-- Insular Region (same as Galápagos but listed separately for clarity)
('Santo Domingo de los Tsáchilas', 'Santo Domingo', 4180.13, 458580, -0.2542, -79.1719, 'Costa', 'Named after the Tsáchila indigenous people, known for its agricultural production and the "Colorados" people.');

-- Create indexes for better performance
CREATE INDEX idx_provinces_region ON provinces(region);
CREATE INDEX idx_provinces_name ON provinces(name);
CREATE INDEX idx_provinces_population ON provinces(population);

-- Create a view for province statistics
CREATE VIEW province_stats AS
SELECT 
    region,
    COUNT(*) as province_count,
    SUM(population) as total_population,
    SUM(area_km2) as total_area,
    AVG(population) as avg_population,
    AVG(area_km2) as avg_area
FROM provinces 
GROUP BY region
ORDER BY total_population DESC; 