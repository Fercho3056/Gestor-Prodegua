import 'package:flutter/material.dart';

// 📁 Importar pantallas principales
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

// 📦 Mapa de rutas de la app
final Map<String, WidgetBuilder> rutas = {
  '/login': (context) => LoginPantalla(),
  '/registro': (context) => RegistroPantalla(),

  // 👇 Secciones por rol
  '/perfil-cliente': (context) => PerfilCliente(),
  '/perfil-tecnico': (context) => PerfilTecnico(),
  '/panel-admin': (context) => PanelAdmin(),

  // 👇 Cliente
  '/solicitar-servicio': (context) => const SolicitarServicio(),
  '/ver-estado': (context) => VerEstadoServicios(),

  // 👇 Administrador
  '/gestion-usuarios': (context) => GestionUsuarios(),
  '/gestion-servicios': (context) => GestionServicios(),
  '/usuarios-admin': (context) => const UsuariosAdminPantalla(),
};
