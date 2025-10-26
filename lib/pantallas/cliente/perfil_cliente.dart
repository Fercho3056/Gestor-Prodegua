import 'package:flutter/material.dart';
import '../compartido/perfil_usuario.dart';

class PerfilCliente extends StatelessWidget {
  final String correo;
  const PerfilCliente({super.key, required this.correo});

  @override
  Widget build(BuildContext context) {
    return PerfilUsuario(correo: correo, rol: 'cliente');
  }
}
