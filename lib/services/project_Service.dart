import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_model.dart';

class ProjectService {
  static final ProjectService _instance = ProjectService._internal();
  factory ProjectService() => _instance;
  ProjectService._internal();

  static const String boxName = 'projects';
  Box<ProjectModel>? _box;

  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<ProjectModel>(boxName);
    }
  }

  Box<ProjectModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw StateError('Box not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> addProject(ProjectModel project) async {
    await init();
    await box.add(project);
  }

  List<ProjectModel> getActiveProjects() {
    try {
      return box.values.where((project) => project.isActive).toList();
    } catch (e) {
      print('Error en getActiveProjects: $e');
      return [];
    }
  }

  List<ProjectModel> searchProjects(String query) {
    try {
      return box.values.where((project) => 
        project.isActive &&
        ((project.clienteNombre?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (project.proveedorNombre?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (project.descripcion?.toLowerCase().contains(query.toLowerCase()) ?? false))
      ).toList();
    } catch (e) {
      print('Error en searchProjects: $e');
      return [];
    }
  }
}