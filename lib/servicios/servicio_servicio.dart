// lib/servicios/servicio_servicio.dart
import 'base_datos.dart';

class ServicioServicio {
  // Crear solicitud (cliente)
  Future<int> crearSolicitud(
      String nombre, String descripcion, String clienteCorreo) async {
    return await BaseDatos.insertarServicio(
        nombre, descripcion, 'pendiente', clienteCorreo);
  }

  // Listar servicios (todos / por cliente / por tecnico)
  Future<List<Map<String, dynamic>>> listarServicios(
      {String? cliente, String? tecnico}) async {
    return await BaseDatos.obtenerServicios(cliente: cliente, tecnico: tecnico);
  }

  // Actualizar estado
  Future<int> cambiarEstado(int id, String nuevoEstado) async {
    return await BaseDatos.actualizarEstadoServicio(id, nuevoEstado);
  }

  // Asignar técnico
  Future<int> asignarTecnico(int id, String tecnicoCorreo) async {
    return await BaseDatos.asignarTecnico(id, tecnicoCorreo);
  }

  // Eliminar servicio
  Future<int> eliminar(int id) async {
    return await BaseDatos.eliminarServicio(id);
  }
}
