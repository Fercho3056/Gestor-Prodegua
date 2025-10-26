import 'package:flutter/material.dart';
import '../compartido/perfil_usuario.dart';

class PerfilTecnico extends StatelessWidget {
  final String correo;
  const PerfilTecnico({super.key, required this.correo});

  @override
  Widget build(BuildContext context) {
    return PerfilUsuario(correo: correo, rol: 'tecnico');
  }
}
