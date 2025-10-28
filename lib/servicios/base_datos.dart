import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; // Para móviles
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Para escritorio

class BaseDatos {
  static Database? _database;

  // ==========================================================
  // 🔹 Inicialización general de la base de datos
  // ==========================================================
  static Future<Database> get database async {
    if (_database != null) return _database!;
    print('📦 Inicializando base de datos...');

    // Inicialización multiplataforma
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } else {
      databaseFactory =
          databaseFactory; // Para Android/iOS usa la fábrica normal
    }

    _database = await _inicializar();
    return _database!;
  }

  static Future<Database> _inicializar() async {
    // Definir ruta según plataforma
    String path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      path = join(Directory.current.path, 'prodegua.db'); // Desktop
    } else {
      path = join(await getDatabasesPath(), 'prodegua.db'); // Android/iOS
    }

    print('📁 Ruta de la base: $path');

    // Abrir la base de datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('🆕 Creando tablas...');
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            correo TEXT UNIQUE,
            contrasena TEXT,
            rol TEXT,
            foto TEXT
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
    );
  }

  // ==========================================================
  // 👤 MÉTODOS DE USUARIOS
  // ==========================================================

  /// Obtiene un usuario por correo
  static Future<Map<String, dynamic>?> obtenerUsuarioPorCorreo(
      String correo) async {
    final db = await database;
    final res =
        await db.query('usuarios', where: 'correo = ?', whereArgs: [correo]);
    return res.isNotEmpty ? res.first : null;
  }

  /// Obtiene un usuario por correo y contraseña
  static Future<Map<String, dynamic>?> obtenerUsuarioPorCredenciales(
      String correo, String contrasena) async {
    final db = await database;
    final res = await db.query('usuarios',
        where: 'correo = ? AND contrasena = ?',
        whereArgs: [correo, contrasena]);
    return res.isNotEmpty ? res.first : null;
  }

  /// Inserta un nuevo usuario (correo, contraseña, rol)
  static Future<int> insertarUsuario(
      String correo, String contrasena, String rol) async {
    final db = await database;
    return await db.insert(
      'usuarios',
      {
        'correo': correo,
        'contrasena': contrasena,
        'rol': rol,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Obtiene todos los usuarios
  static Future<List<Map<String, dynamic>>> obtenerTodosUsuarios() async {
    final db = await database;
    return await db.query('usuarios', orderBy: 'id DESC');
  }

  /// Elimina un usuario por ID
  static Future<int> eliminarUsuario(int id) async {
    final db = await database;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================================
  // 🧰 MÉTODOS DE SERVICIOS
  // ==========================================================

  /// Inserta un nuevo servicio
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

  /// Obtiene todos los servicios o los del cliente/técnico
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

  /// Actualiza el estado de un servicio
  static Future<int> actualizarEstadoServicio(
      int id, String nuevoEstado) async {
    final db = await database;
    return await db.update('servicios', {'estado': nuevoEstado},
        where: 'id = ?', whereArgs: [id]);
  }

  /// Asigna un técnico a un servicio
  static Future<int> asignarTecnico(int id, String tecnicoCorreo) async {
    final db = await database;
    return await db.update(
        'servicios', {'tecnico': tecnicoCorreo, 'estado': 'asignado'},
        where: 'id = ?', whereArgs: [id]);
  }

  /// Elimina un servicio por ID
  static Future<int> eliminarServicio(int id) async {
    final db = await database;
    return await db.delete('servicios', where: 'id = ?', whereArgs: [id]);
  }
}
