import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BaseDatos {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    print('📦 Inicializando base de datos...');
    _database = await _inicializar();
    return _database!;
  }

  static Future<Database> _inicializar() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'prodegua.db');

    print('📁 Ruta de la base: $path');

    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            print('🆕 Creando tablas...');
            await db.execute('''
              CREATE TABLE usuarios (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                correo TEXT UNIQUE,
                contrasena TEXT,
                rol TEXT
              )
            ''');

            await db.execute('''
              CREATE TABLE servicios (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nombre TEXT,
                descripcion TEXT,
                estado TEXT,
                cliente TEXT,
                tecnico TEXT,
                fecha_creacion TEXT
              )
            ''');

            print('✅ Tablas creadas correctamente');
          },
        ));
  }

  // ==========================================================
  // 👤 MÉTODOS DE USUARIOS
  // ==========================================================

  static Future<Map<String, dynamic>?> obtenerUsuarioPorCorreo(
      String correo) async {
    final db = await database;
    final res =
        await db.query('usuarios', where: 'correo = ?', whereArgs: [correo]);
    return res.isNotEmpty ? res.first : null;
  }

  static Future<Map<String, dynamic>?> obtenerUsuarioPorCredenciales(
      String correo, String contrasena) async {
    final db = await database;
    final res = await db.query('usuarios',
        where: 'correo = ? AND contrasena = ?',
        whereArgs: [correo, contrasena]);
    return res.isNotEmpty ? res.first : null;
  }

  static Future<int> insertarUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> obtenerTodosUsuarios() async {
    final db = await database;
    return await db.query('usuarios', orderBy: 'id DESC');
  }

  static Future<int> eliminarUsuario(int id) async {
    final db = await database;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================================
  // 🧰 MÉTODOS DE SERVICIOS
  // ==========================================================

  static Future<int> insertarServicio(
      String nombre, String descripcion, String estado, String clienteCorreo,
      {String tecnicoCorreo = ''}) async {
    final db = await database;
    final fecha = DateTime.now().toIso8601String();
    return await db.insert('servicios', {
      'nombre': nombre,
      'descripcion': descripcion,
      'estado': estado,
      'cliente': clienteCorreo,
      'tecnico': tecnicoCorreo,
      'fecha_creacion': fecha,
    });
  }

  static Future<List<Map<String, dynamic>>> obtenerServicios(
      {String? cliente, String? tecnico}) async {
    final db = await database;
    if (cliente != null) {
      return await db.query('servicios',
          where: 'cliente = ?', whereArgs: [cliente], orderBy: 'id DESC');
    } else if (tecnico != null) {
      return await db.query('servicios',
          where: 'tecnico = ?', whereArgs: [tecnico], orderBy: 'id DESC');
    } else {
      return await db.query('servicios', orderBy: 'id DESC');
    }
  }

  static Future<int> actualizarEstadoServicio(
      int id, String nuevoEstado) async {
    final db = await database;
    return await db.update('servicios', {'estado': nuevoEstado},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> asignarTecnico(int id, String tecnicoCorreo) async {
    final db = await database;
    return await db.update(
        'servicios', {'tecnico': tecnicoCorreo, 'estado': 'asignado'},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> eliminarServicio(int id) async {
    final db = await database;
    return await db.delete('servicios', where: 'id = ?', whereArgs: [id]);
  }
}
