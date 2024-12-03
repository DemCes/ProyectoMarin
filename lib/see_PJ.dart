import 'package:flutter/material.dart';
import '../services/project_service.dart';
import '../models/project_model.dart';

class SeePJ extends StatefulWidget {
  const SeePJ({super.key});

  @override
  State<SeePJ> createState() => _SeeSupplierState();
}

class _SeeSupplierState extends State<SeePJ> {
  final TextEditingController _searchController = TextEditingController();
  final ProjectService _projectService = ProjectService();
  List<ProjectModel> _projects = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await _projectService.init();
      _loadProjects();
    } catch (e) {
      print('Error inicializando servicio: $e');
    }
  }

  void _loadProjects() {
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_searchText.isEmpty) {
        _projects = _projectService.getActiveProjects();
      } else {
        _projects = _projectService.searchProjects(_searchText);
      }
    } catch (e) {
      print('Error cargando proyectos: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8470A1),
      body: SafeArea(
        child: Column(
          children: [
            buildTitle(context),
            buildSearchContainer(),
            buildContentContainer(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Proyectos',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 24, 
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget buildSearchContainer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF463D5E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _searchText = text;
                      _loadProjects();
                    });
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.search, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContentContainer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2740),
          borderRadius: BorderRadius.circular(30),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _projects.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'No hay proyectos registrados',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _projects.length,
                    itemBuilder: (context, index) {
                      final project = _projects[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E0F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.business, color: Colors.black54, size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${project.clienteNombre ?? "Sin cliente"} - ${project.proveedorNombre ?? "Sin proveedor"}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Text(
                                project.descripcion ?? 'Sin descripción',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}