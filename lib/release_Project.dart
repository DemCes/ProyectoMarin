import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../models/provider_model.dart';
import '../services/client_service.dart';
import '../services/provider_service.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

class Release_project extends StatefulWidget {
  const Release_project({super.key});

  @override
  _ReleaseProjectState createState() => _ReleaseProjectState();
}

class _ReleaseProjectState extends State<Release_project> {
  ClientModel? selectedClient;
  ProviderModel? selectedProvider;
  final TextEditingController _Comments = TextEditingController();
  
  // Servicios
  final ClientService _clientService = ClientService();
  final ProviderService _providerService = ProviderService();
  
  // Listas para almacenar los datos
  List<ClientModel> clients = [];
  List<ProviderModel> providers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);
    try {
      await _clientService.init();
      await _providerService.init();
      _loadData();
    } catch (e) {
      print('Error inicializando servicios: $e');
    }
    setState(() => _isLoading = false);
  }

  void _loadData() {
    try {
      clients = _clientService.getActiveClients();
      providers = _providerService.getActiveProviders();
      
      // Seleccionar el primer elemento de cada lista si existe
      if (clients.isNotEmpty) {
        selectedClient = clients.first;
      }
      if (providers.isNotEmpty) {
        selectedProvider = providers.first;
      }
    } catch (e) {
      print('Error cargando datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8470A1),
      body: SafeArea(
        child: Column(
          children: [
            buildTitle(context),
            buildFormContainer(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Alta proyectos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget buildFormContainer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2740),
          borderRadius: BorderRadius.circular(30),
        ),
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Dropdown de Clientes
                  DropdownButton<ClientModel>(
                    value: selectedClient,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color(0xFF463D5E),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: const Text(
                      'Seleccionar Cliente',
                      style: TextStyle(color: Colors.white54),
                    ),
                    items: clients.map((ClientModel client) {
                      return DropdownMenuItem<ClientModel>(
                        value: client,
                        child: Text(client.nombre ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (ClientModel? newValue) {
                      setState(() {
                        selectedClient = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Dropdown de Proveedores
                  DropdownButton<ProviderModel>(
                    value: selectedProvider,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color(0xFF463D5E),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: const Text(
                      'Seleccionar Proveedor',
                      style: TextStyle(color: Colors.white54),
                    ),
                    items: providers.map((ProviderModel provider) {
                      return DropdownMenuItem<ProviderModel>(
                        value: provider,
                        child: Text(provider.nombre ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (ProviderModel? newValue) {
                      setState(() {
                        selectedProvider = newValue;
                      });
                    },
                  ),
                  buildTextField(_Comments, 'Descripcion'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text(
                      'Agregar',
                      style: TextStyle(
                        color: Color(0xFF2F2740),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF463D5E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
        ),
      ),
    );
  }

  void submitForm() async {
  if (selectedClient == null || selectedProvider == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor selecciona un cliente y un proveedor')),
    );
    return;
  }

  if (_Comments.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor agrega una descripción')),
    );
    return;
  }

  try {
    final ProjectModel newProject = ProjectModel(
      clienteNombre: selectedClient?.nombre,
      proveedorNombre: selectedProvider?.nombre,
      descripcion: _Comments.text,
    );

    await ProjectService().addProject(newProject);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proyecto guardado exitosamente')),
    );
    
    // Limpiar el formulario
    setState(() {
      selectedClient = null;
      selectedProvider = null;
      _Comments.clear();
    });

  } catch (e) {
    print('Error al guardar proyecto: $e');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar el proyecto: $e')),
    );
  }
}

  @override
  void dispose() {
    _Comments.dispose();
    super.dispose();
  }
}