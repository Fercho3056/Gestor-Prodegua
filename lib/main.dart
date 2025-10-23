import 'package:flutter/material.dart';
import 'rutas.dart';
import 'servicios/base_datos.dart';

Future<void> crearAdminSiNoExiste() async {
  final adminExistente =
      await BaseDatos.obtenerUsuarioPorCorreo('admin@prodegua.com');

  if (adminExistente == null) {
    await BaseDatos.insertarUsuario({
      'correo': 'admin@prodegua.com',
      'contrasena': 'admin123',
      'rol': 'admin',
    });
    print('✅ Usuario admin creado correctamente');
  } else {
    print('ℹ️ Usuario admin ya existe');
  }
}

Future<void> crearTecnicoSiNoExiste() async {
  final tecnicoExistente =
      await BaseDatos.obtenerUsuarioPorCorreo('tecnico@prodegua.com');

  if (tecnicoExistente == null) {
    await BaseDatos.insertarUsuario({
      'correo': 'tecnico@prodegua.com',
      'contrasena': 'tec123',
      'rol': 'tecnico',
    });
    print('✅ Usuario técnico creado correctamente');
  } else {
    print('ℹ️ Usuario técnico ya existe');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la base de datos
  await BaseDatos.database;

  // Inserta el admin si no existe
  await crearAdminSiNoExiste();

  runApp(ProdeguaApp());
}

class ProdeguaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prodegua (modo local)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: rutas,
    );
  }
}
