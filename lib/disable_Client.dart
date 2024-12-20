import 'package:flutter/material.dart';
import '../services/client_service.dart';
import '../models/client_model.dart';

class DisableClient extends StatefulWidget {
  const DisableClient({super.key});

  @override
  State<DisableClient> createState() => _DisableClientState();
}

class _DisableClientState extends State<DisableClient> {
  final TextEditingController _searchController = TextEditingController();
  final ClientService _clientService = ClientService();
  List<ClientModel> _disabledClients = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await _clientService.init();
      _loadDisabledClients();
    } catch (e) {
      print('Error inicializando servicio: $e');
    }
  }

  void _loadDisabledClients() {
    setState(() {
      _isLoading = true;
    });
    
    try {
      _disabledClients = _clientService.getDisabledClients();
      if (_searchText.isNotEmpty) {
        _disabledClients = _disabledClients
          .where((client) =>
            (client.nombre?.toLowerCase() ?? '').contains(_searchText.toLowerCase()) ||
            (client.correoElectronico?.toLowerCase() ?? '').contains(_searchText.toLowerCase()))
          .toList();
      }
    } catch (e) {
      print('Error cargando clientes deshabilitados: $e');
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
            'Clientes Inhabilitados',
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
                      _loadDisabledClients();
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
            : _disabledClients.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'No hay clientes inhabilitados',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _disabledClients.length,
                    itemBuilder: (context, index) {
                      final client = _disabledClients[index];
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
                                    client.nombre ?? 'Nombre no disponible',
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
                                    'RFC:\n${client.rfc ?? 'No disponible'}',
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                                Text(
                                  'Teléfono:\n${client.telefono ?? 'No disponible'}',
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${client.correoElectronico ?? 'No disponible'}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Dirección: ${client.direccion ?? 'No disponible'}',
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
                                            "¿Estás seguro de que deseas restaurar al cliente ${client.nombre}?",
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
                                                  final clientIndex = _clientService.getClientIndex(client);
                                                  if (clientIndex != null) {
                                                    await _clientService.restoreClient(clientIndex);
                                                    _loadDisabledClients();
                                                    if (!mounted) return;
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Cliente restaurado exitosamente'),
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  print('Error al restaurar cliente: $e');
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