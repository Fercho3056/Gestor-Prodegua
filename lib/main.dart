import 'package:flutter/material.dart';
import 'rutas.dart';
import 'servicios/base_datos.dart';

Future<void> crearAdminYtecnico() async {
  final admin = await BaseDatos.obtenerUsuarioPorCorreo('admin@prodegua.com');
  final tecnico =
      await BaseDatos.obtenerUsuarioPorCorreo('tecnico@prodegua.com');

  if (admin == null) {
    await BaseDatos.insertarUsuario(
      'admin@prodegua.com',
      'admin123',
      'admin',
    );
    print('✅ Usuario admin creado');
  }

  if (tecnico == null) {
    await BaseDatos.insertarUsuario(
      'tecnico@prodegua.com',
      'tec123',
      'tecnico',
    );
    print('✅ Usuario técnico creado');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BaseDatos.database;
  await crearAdminYtecnico();

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
      ),
      initialRoute: '/login',
      routes: rutas,
    );
  }
}
