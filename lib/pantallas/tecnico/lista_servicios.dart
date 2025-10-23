import 'package:flutter/material.dart';

class ListaServiciosPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de servicios asignados")),
      body: Center(child: Text("Pantalla donde el técnico ve sus servicios")),
    );
  }
}
