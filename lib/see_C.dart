import 'package:flutter/material.dart';
import 'package:flutter_application_1/release_Client.dart';
import '../services/client_service.dart';
import '../models/client_model.dart';

class SeeC extends StatefulWidget {
  const SeeC({super.key});

  @override
  State<SeeC> createState() => _SeeCState();
}

class _SeeCState extends State<SeeC> {
  final TextEditingController _searchController = TextEditingController();
  final ClientService _clientService = ClientService();
  List<ClientModel> _clients = [];
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
      _loadClients();
    } catch (e) {
      print('Error inicializando servicio: $e');
    }
  }

  void _loadClients() {
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_searchText.isEmpty) {
        _clients = _clientService.getActiveClients();
      } else {
        _clients = _clientService.searchClients(_searchText);
      }
    } catch (e) {
      print('Error cargando clientes: $e');
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
            'Clientes',
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
                      _loadClients();
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
            : _clients.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'No hay clientes registrados',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _clients.length,
                    itemBuilder: (context, index) {
                      final client = _clients[index];
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
                            client.nombre ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: ${client.correoElectronico ?? ''}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                              Text(
                                'Teléfono: ${client.telefono ?? ''}',
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
                                    final clientIndex = _clientService.getClientIndex(client);
                                    if (clientIndex != null) {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Release_Client(
                                            client: client,
                                            clientIndex: clientIndex,
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadClients();
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No se pudo encontrar el cliente')),
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
                                        content: const Text("¿Estás seguro de que quieres inhabilitar este cliente?"),
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
                                                  await _clientService.disableClient(clientIndex);
                                                  _loadClients();
                                                  if (!mounted) return;
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Cliente inhabilitado exitosamente'),
                                                      duration: Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                print('Error al inhabilitar cliente: $e');
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