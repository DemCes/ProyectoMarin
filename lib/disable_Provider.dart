import 'package:flutter/material.dart';
import '../services/provider_service.dart';
import '../models/provider_model.dart';

class DisableProvider extends StatefulWidget {
  const DisableProvider({super.key});

  @override
  State<DisableProvider> createState() => _DisableProviderState();
}

class _DisableProviderState extends State<DisableProvider> {
  final TextEditingController _searchController = TextEditingController();
  final ProviderService _providerService = ProviderService();
  List<ProviderModel> _disabledProviders = [];
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
      _loadDisabledProviders();
    } catch (e) {
      print('Error inicializando servicio: $e');
    }
  }

  void _loadDisabledProviders() {
    setState(() {
      _isLoading = true;
    });
    
    try {
      _disabledProviders = _providerService.getDisabledProviders();
      if (_searchText.isNotEmpty) {
        _disabledProviders = _disabledProviders
          .where((provider) =>
            (provider.nombre?.toLowerCase() ?? '').contains(_searchText.toLowerCase()) ||
            (provider.correoElectronico?.toLowerCase() ?? '').contains(_searchText.toLowerCase()))
          .toList();
      }
    } catch (e) {
      print('Error cargando proveedores deshabilitados: $e');
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
            'Proveedores Inhabilitados',
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
                      _loadDisabledProviders();
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
            : _disabledProviders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'No hay proveedores inhabilitados',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _disabledProviders.length,
                    itemBuilder: (context, index) {
                      final provider = _disabledProviders[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
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
                                const Icon(Icons.person, color: Colors.black54, size: 30),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    provider.nombre ?? 'Nombre no disponible',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'RFC:\n${provider.rfc ?? 'No disponible'}',
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                                Text(
                                  'Teléfono:\n${provider.telefono ?? 'No disponible'}',
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${provider.correoElectronico ?? 'No disponible'}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Dirección: ${provider.direccion ?? 'No disponible'}',
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.restore, color: Colors.green),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirmar Restauración"),
                                          content: Text(
                                            "¿Estás seguro de que deseas restaurar al proveedor ${provider.nombre}?",
                                          ),
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
                                                    await _providerService.restoreProvider(providerIndex);
                                                    _loadDisabledProviders();
                                                    if (!mounted) return;
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Proveedor restaurado exitosamente'),
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  print('Error al restaurar proveedor: $e');
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: $e')),
                                                  );
                                                }
                                              },
                                              child: const Text("Restaurar"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
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