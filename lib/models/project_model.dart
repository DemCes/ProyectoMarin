import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 2)  // Usamos 2 porque 0 y 1 ya están usados por Client y Provider
class ProjectModel extends HiveObject {
  @HiveField(0)
  String? clienteNombre;

  @HiveField(1)
  String? proveedorNombre;

  @HiveField(2)
  String? descripcion;

  @HiveField(3)
  bool isActive;

  ProjectModel({
    this.clienteNombre,
    this.proveedorNombre,
    this.descripcion,
    this.isActive = true,
  });
}