import 'package:flutter/material.dart';

// 📁 Importar pantallas principales
import 'pantallas/autenticacion/login.dart';
import 'pantallas/autenticacion/registro.dart';
import 'pantallas/cliente/perfil_cliente.dart';
import 'pantallas/cliente/solicitar_servicio.dart';
import 'pantallas/cliente/ver_estado_servicios.dart';
import 'pantallas/tecnico/perfil_tecnico.dart';
import 'pantallas/admin/perfil_admin.dart';
import 'pantallas/admin/panel_admin.dart';
import 'pantallas/admin/gestion_usuarios.dart';
import 'pantallas/admin/gestion_servicios.dart';
import 'pantallas/admin/usuarios_admin.dart';
import 'pantallas/compartido/editar_perfil.dart';

final Map<String, WidgetBuilder> rutas = {
  '/login': (context) => LoginPantalla(),
  '/registro': (context) => RegistroPantalla(),

  // 👇 Perfiles personalizados
  '/perfil-cliente': (context) =>
      const PerfilCliente(correo: 'cliente@prodegua.com'),
  '/perfil-tecnico': (context) =>
      const PerfilTecnico(correo: 'tecnico@prodegua.com'),
  '/perfil-admin': (context) => const PerfilAdmin(correo: 'admin@prodegua.com'),

  // 👇 Funciones por rol
  '/solicitar-servicio': (context) => const SolicitarServicio(),
  '/ver-estado': (context) => VerEstadoServicios(),
  '/panel-admin': (context) => const PanelAdmin(),
  '/gestion-usuarios': (context) => GestionUsuarios(),
  '/gestion-servicios': (context) => GestionServicios(),
  '/usuarios-admin': (context) => const UsuariosAdminPantalla(),

  // 🔧 Editar perfil
  '/editar-perfil': (context) =>
      const EditarPerfil(correo: 'cliente@prodegua.com'),
};
