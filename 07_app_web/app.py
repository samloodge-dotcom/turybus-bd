from flask import Flask, jsonify, request, send_from_directory
import mysql.connector

app = Flask(__name__, static_folder='.')

DB_HOST = '127.0.0.1'
DB_PORT = 3306
DB_NAME = 'turybus'

def get_conn(user, password):
    return mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=user,
        password=password,
        database=DB_NAME
    )

@app.route('/')
def home():
    return send_from_directory('.', 'index.html')

@app.route('/api/catalogo', methods=['GET'])
def obtener_catalogo():
    conn = get_conn('usr_auditor', 'Auditor2026')
    cur = conn.cursor(dictionary=True)

    cur.execute("SELECT * FROM ruta")
    rutas = cur.fetchall()

    cur.execute("SELECT id_servicio, nombre_ruta, TIME_FORMAT(hora_salida, '%H:%i:%s') AS hora_salida, TIME_FORMAT(hora_llegada, '%H:%i:%s') AS hora_llegada, dias_programados, matricula, dni_conductor FROM servicio_diario")
    servicios = cur.fetchall()

    cur.execute("SELECT * FROM lugar")
    lugares = cur.fetchall()

    cur.execute("SELECT id_detalle, nombre_ruta, orden, id_lugar, TIME_FORMAT(hora_llegada_prevista, '%H:%i:%s') AS hora_llegada_prevista, CAST(tiempo_parada AS FLOAT) AS tiempo_parada, actividad FROM detalle_ruta ORDER BY orden ASC")
    detalles = cur.fetchall()

    cur.execute("SELECT id_billete, dni_pasajero, id_servicio, DATE_FORMAT(fecha, '%Y-%m-%d') AS fecha, CAST(importe AS FLOAT) AS importe FROM billete ORDER BY id_billete DESC")
    billetes = cur.fetchall()

    cur.execute("SELECT * FROM pasajero")
    pasajeros = cur.fetchall()

    cur.execute("SELECT * FROM autobus")
    autobuses = cur.fetchall()

    cur.execute("SELECT * FROM conductor")
    conductores = cur.fetchall()

    cur.execute("""
        SELECT r.id_revision, r.matricula, DATE_FORMAT(r.fecha_revision, '%Y-%m-%d') AS fecha_revision,
               r.diagnostico, COALESCE(rep.codigo_reparacion, 'N/A') AS codigo_reparacion,
               COALESCE(CAST(rep.tiempo_empleado AS FLOAT), 0) AS tiempo_empleado
        FROM revision r
        LEFT JOIN reparacion rep ON r.id_revision = rep.id_revision
        ORDER BY r.id_revision DESC
    """)
    revisiones = cur.fetchall()

    cur.close()
    conn.close()

    return jsonify({
        'rutas': rutas,
        'servicios': servicios,
        'lugares': lugares,
        'detalles': detalles,
        'billetes': billetes,
        'pasajeros': pasajeros,
        'autobuses': autobuses,
        'conductores': conductores,
        'revisiones': revisiones
    })

@app.route('/api/emitir_billete', methods=['POST'])
def emitir_billete():
    datos = request.get_json()
    conn = None
    try:
        conn = get_conn('usr_taquilla', 'Taquilla2026')
        cur = conn.cursor()
        cur.callproc('sp_emitir_billete', [
            datos['dni'],
            datos['nombre'],
            datos['telefono'],
            int(datos['id_servicio']),
            datos['fecha']
        ])
        conn.commit()
        cur.close()
        return jsonify({'ok': True, 'mensaje': 'Billete emitido vía MySQL sp_emitir_billete'})
    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({'ok': False, 'error': str(e)}), 400
    finally:
        if conn:
            conn.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
