import 'package:flutter/material.dart';
import 'pantallas/autenticacion/login.dart';
import 'pantallas/autenticacion/registro.dart';
import 'pantallas/cliente/perfil_cliente.dart';
import 'pantallas/cliente/solicitar_servicio.dart';
import 'pantallas/cliente/ver_estado_servicios.dart';
import 'pantallas/tecnico/perfil_tecnico.dart';
import 'pantallas/admin/panel_admin.dart';
import 'pantallas/admin/gestion_usuarios.dart';
import 'pantallas/admin/gestion_servicios.dart';
import 'pantallas/admin/usuarios_admin.dart';

final Map<String, WidgetBuilder> rutas = {
  '/login': (context) => LoginPantalla(),
  '/registro': (context) => RegistroPantalla(),
  '/perfil-cliente': (context) => PerfilCliente(),
  '/perfil-tecnico': (context) => PerfilTecnico(),
  '/panel-admin': (context) => PanelAdmin(),
  '/solicitar-servicio': (context) => SolicitarServicio(),
  '/ver-estado': (context) => VerEstadoServicios(),
  '/gestion-usuarios': (context) => GestionUsuarios(),
  '/gestion-servicios': (context) => GestionServicios(),
  '/usuarios-admin': (context) => const UsuariosAdminPantalla(),
};
