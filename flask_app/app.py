from flask import Flask, render_template, jsonify
from flask_cors import CORS
import mysql.connector
import os
from datetime import datetime
import random

app = Flask(__name__)
CORS(app)

# Database configuration
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv('MYSQL_HOST', 'mysql'),
        user=os.getenv('MYSQL_USER', 'ecuador_user'),
        password=os.getenv('MYSQL_PASSWORD', 'ecuador_pass'),
        database=os.getenv('MYSQL_DATABASE', 'ecuador_db'),
        charset='utf8mb4',
        collation='utf8mb4_unicode_ci',
        autocommit=True
    )

@app.route('/')
def index():
    """Main page with Ecuador map"""
    google_maps_api_key = os.getenv('GOOGLE_MAPS_API_KEY', '')
    return render_template('index.html', api_key=google_maps_api_key)

@app.route('/api/provinces')
def get_provinces():
    """API endpoint to get all provinces data"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT id, name, capital, area_km2, population, 
                   latitude, longitude, region
            FROM provinces 
            ORDER BY name
        """)
        
        provinces = cursor.fetchall()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'data': provinces,
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e),
            'timestamp': datetime.now().isoformat()
        }), 500

@app.route('/api/province/<int:province_id>')
def get_province(province_id):
    """API endpoint to get specific province data"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT id, name, capital, area_km2, population, 
                   latitude, longitude, region, description
            FROM provinces 
            WHERE id = %s
        """, (province_id,))
        
        province = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if province:
            return jsonify({
                'success': True,
                'data': province,
                'timestamp': datetime.now().isoformat()
            })
        else:
            return jsonify({
                'success': False,
                'error': 'Province not found',
                'timestamp': datetime.now().isoformat()
            }), 404
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e),
            'timestamp': datetime.now().isoformat()
        }), 500

@app.route('/api/health')
def health_check():
    """Health check endpoint for load balancer"""
    return jsonify({
        'status': 'healthy',
        'service': 'flask_app',
        'timestamp': datetime.now().isoformat(),
        'instance': random.randint(1, 1000)  # To identify different instances
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False) 