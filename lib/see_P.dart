import 'package:flutter/material.dart';
import 'package:flutter_application_1/release_Provider.dart';
import '../services/provider_service.dart';
import '../models/provider_model.dart';

class SeeP extends StatefulWidget {
  const SeeP({super.key});

  @override
  State<SeeP> createState() => _SeePState();
}

class _SeePState extends State<SeeP> {
  final TextEditingController _searchController = TextEditingController();
  final ProviderService _providerService = ProviderService();
  List<ProviderModel> _providers = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await _providerService.init();
      _loadProviders();
    } catch (e) {
      print('Error inicializando servicio: $e');
    }
  }

  void _loadProviders() {
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_searchText.isEmpty) {
        _providers = _providerService.getActiveProviders();
      } else {
        _providers = _providerService.searchProviders(_searchText);
      }
    } catch (e) {
      print('Error cargando proveedores: $e');
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
            'Proveedores',
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
                      _loadProviders();
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
            : _providers.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'No hay proveedores registrados',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _providers.length,
                    itemBuilder: (context, index) {
                      final provider = _providers[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E0F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ListTile(
                          title: Text(
                            provider.nombre ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: ${provider.correoElectronico ?? ''}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                              Text(
                                'Teléfono: ${provider.telefono ?? ''}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  try {
                                    final providerIndex = _providerService.getProviderIndex(provider);
                                    if (providerIndex != null) {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Release_Provider(
                                            provider: provider,
                                            providerIndex: providerIndex,
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadProviders();
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No se pudo encontrar el proveedor')),
                                      );
                                    }
                                  } catch (e) {
                                    print('Error en edición: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content: const Text("¿Estás seguro de que quieres inhabilitar este proveedor?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                final providerIndex = _providerService.getProviderIndex(provider);
                                                if (providerIndex != null) {
                                                  await _providerService.disableProvider(providerIndex);
                                                  _loadProviders();
                                                  if (!mounted) return;
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Proveedor inhabilitado exitosamente'),
                                                      duration: Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                print('Error al inhabilitar proveedor: $e');
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: $e')),
                                                );
                                              }
                                            },
                                            child: const Text("Sí, inhabilitar"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
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