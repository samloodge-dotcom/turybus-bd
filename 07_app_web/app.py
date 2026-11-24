from flask import Flask, jsonify, request, send_from_directory
import mysql.connector
import hashlib

app = Flask(__name__, static_folder='.')

DB_HOST = '127.0.0.1'
DB_PORT = 3306
DB_NAME = 'turybus'

def get_conn(user, password):
    return mysql.connector.connect(
        host=DB_HOST, port=DB_PORT, user=user, password=password, database=DB_NAME
    )

def registrar_bitacora(usuario, accion, detalle):
    try:
        conn = get_conn('usr_auditor', 'Auditor2026')
        cur = conn.cursor()
        cur.execute("INSERT INTO bitacora_auditoria (usuario_evento, accion, detalle) VALUES (%s, %s, %s)",
                    (usuario, accion, detalle))
        conn.commit()
        cur.close()
        conn.close()
    except Exception:
        pass

@app.route('/')
def home():
    return send_from_directory('.', 'index.html')

@app.route('/api/login', methods=['POST'])
def login():
    datos = request.get_json()
    username = datos.get('username', '').strip()
    password = datos.get('password', '')
    pwd_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()

    conn = get_conn('usr_auditor', 'Auditor2026')
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT username, nombre_completo, rol FROM usuarios_app WHERE username = %s AND password_hash = %s AND activo = TRUE",
                (username, pwd_hash))
    user = cur.fetchone()
    cur.close()
    conn.close()

    if not user:
        registrar_bitacora(username or 'desconocido', 'LOGIN_FALLIDO', 'Intento de acceso rechazado (credenciales inválidas)')
        return jsonify({'ok': False, 'error': 'Usuario o contraseña incorrectos'}), 401

    registrar_bitacora(user['username'], 'LOGIN_EXITOSO', f"Inicio de sesión con rol {user['rol']}")
    return jsonify({'ok': True, 'user': user})

@app.route('/api/logout', methods=['POST'])
def logout():
    datos = request.get_json() or {}
    registrar_bitacora(datos.get('username', 'usuario'), 'LOGOUT', 'Cierre de sesión en aplicación web')
    return jsonify({'ok': True})

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
        FROM revision r LEFT JOIN reparacion rep ON r.id_revision = rep.id_revision ORDER BY r.id_revision DESC
    """)
    revisiones = cur.fetchall()
    cur.execute("SELECT id_evento, DATE_FORMAT(fecha_hora, '%Y-%m-%d %H:%i:%s') AS fecha_hora, usuario_evento, accion, detalle FROM bitacora_auditoria ORDER BY id_evento DESC LIMIT 20")
    bitacora = cur.fetchall()
    cur.execute("SELECT username, nombre_completo, rol, activo FROM usuarios_app")
    usuarios = cur.fetchall()

    cur.close()
    conn.close()
    return jsonify({
        'rutas': rutas, 'servicios': servicios, 'lugares': lugares, 'detalles': detalles,
        'billetes': billetes, 'pasajeros': pasajeros, 'autobuses': autobuses,
        'conductores': conductores, 'revisiones': revisiones, 'bitacora': bitacora, 'usuarios': usuarios
    })

@app.route('/api/emitir_billete', methods=['POST'])
def emitir_billete():
    datos = request.get_json()
    rol = datos.get('rol', '')
    if rol not in ('DBA', 'Vendedor'):
        registrar_bitacora(datos.get('username', 'desconocido'), 'ACCESO_DENEGADO', f"Rol {rol} intentó emitir billete")
        return jsonify({'ok': False, 'error': f'El rol {rol} no tiene permiso para emitir billetes'}), 403

    conn = None
    try:
        conn = get_conn('usr_taquilla', 'Taquilla2026')
        cur = conn.cursor()
        cur.callproc('sp_emitir_billete', [
            datos['dni'], datos['nombre'], datos['telefono'], int(datos['id_servicio']), datos['fecha']
        ])
        conn.commit()
        cur.close()
        return jsonify({'ok': True})
    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({'ok': False, 'error': str(e)}), 400
    finally:
        if conn:
            conn.close()

@app.route('/api/registrar_revision', methods=['POST'])
def registrar_revision():
    datos = request.get_json()
    rol = datos.get('rol', '')
    if rol not in ('DBA', 'Operador'):
        return jsonify({'ok': False, 'error': f'El rol {rol} no tiene permiso de taller'}), 403

    conn = None
    try:
        conn = get_conn('usr_taller', 'Taller2026')
        cur = conn.cursor()
        cur.execute("INSERT INTO revision (matricula, fecha_revision, diagnostico) VALUES (%s, %s, %s)",
                    (datos['matricula'], datos['fecha'], datos['diagnostico']))
        conn.commit()
        cur.close()
        registrar_bitacora(datos.get('username', 'operador'), 'ALTA_REVISION', f"Revisión unidad {datos['matricula']}")
        return jsonify({'ok': True})
    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({'ok': False, 'error': str(e)}), 400
    finally:
        if conn:
            conn.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, threaded=True)
