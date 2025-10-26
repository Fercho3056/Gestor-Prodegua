import 'package:flutter/material.dart';
import '../compartido/perfil_usuario.dart';

class PerfilAdmin extends StatelessWidget {
  final String correo;
  const PerfilAdmin({super.key, required this.correo});

  @override
  Widget build(BuildContext context) {
    return PerfilUsuario(correo: correo, rol: 'admin');
  }
}
