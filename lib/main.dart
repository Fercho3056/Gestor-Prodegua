import 'package:flutter/material.dart';
import 'rutas.dart';

void main() {
  runApp(const ProdeguaApp());
}

class ProdeguaApp extends StatelessWidget {
  const ProdeguaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prodegua (modo local)',
      initialRoute: '/login',
      routes: rutas,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
