import 'package:flutter/material.dart';
import 'rutas.dart';
import 'servicios/base_datos.dart';

/// 🧑‍💻 Crea usuario admin si no existe
Future<void> crearAdminSiNoExiste() async {
  final adminExistente =
      await BaseDatos.obtenerUsuarioPorCorreo('admin@prodegua.com');

  if (adminExistente == null) {
    await BaseDatos.insertarUsuario(
      'admin@prodegua.com',
      'admin123',
      'admin',
    );
    print('✅ Usuario admin creado correctamente');
  } else {
    print('ℹ️ Usuario admin ya existe');
  }
}

/// 🔧 Crea usuario técnico si no existe
Future<void> crearTecnicoSiNoExiste() async {
  final tecnicoExistente =
      await BaseDatos.obtenerUsuarioPorCorreo('tecnico@prodegua.com');

  if (tecnicoExistente == null) {
    await BaseDatos.insertarUsuario(
      'tecnico@prodegua.com',
      'tec123',
      'tecnico',
    );
    print('✅ Usuario técnico creado correctamente');
  } else {
    print('ℹ️ Usuario técnico ya existe');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la base de datos
  await BaseDatos.database;

  // Inserta el admin y técnico si no existen
  await crearAdminSiNoExiste();
  await crearTecnicoSiNoExiste();

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
