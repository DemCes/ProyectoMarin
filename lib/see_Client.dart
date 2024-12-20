import 'package:flutter/material.dart';
import 'package:flutter_application_1/see_C.dart';
import 'package:flutter_application_1/release_Client.dart';
import 'package:flutter_application_1/disable_Client.dart';
import '../services/client_service.dart';
import '../models/client_model.dart';

class SeeClient extends StatefulWidget {
  const SeeClient({super.key});

  @override
  State<SeeClient> createState() => _SeeClientState();
}

class _SeeClientState extends State<SeeClient> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  late TabController _tabController;

  // Ya no necesitamos estas listas porque Hive maneja el almacenamiento
  // List<Map<String, String>> clients = [];
  // List<Map<String, String>> disabledClients = [];

  // Inicializar el servicio de Hive
  final ClientService _clientService = ClientService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _clientService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    //_clientService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8470A1),
      body: SafeArea(
        child: Column(
          children: [
            buildTitle(context),
            buildTabMenu(),
            Expanded(child: buildTabContent()),
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Text(
            'Clientes',
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

  Widget buildTabMenu() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      tabs: const [
        Tab(text: "Clientes"),
        Tab(text: 'Crear Clientes'),
        Tab(text: 'Clientes Inhabilitados'),
      ],
    );
  }

  Widget buildTabContent() {
  return TabBarView(
    controller: _tabController,
    children: [
      SeeC(key: UniqueKey()),  // Agrega keys únicas
      Release_Client(key: UniqueKey()),
      DisableClient(key: UniqueKey()),
    ],
  );

  // Ya no necesitamos estos métodos porque Hive maneja el almacenamiento directamente
  // void addClient(Map<String, String> clientData) { ... }
  // void disableClient(Map<String, String> client) { ... }
  // void restoreClient(Map<String, String> client) { ... }
}
}