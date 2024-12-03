import 'package:flutter/material.dart';
import 'package:flutter_application_1/see_P.dart';
import 'package:flutter_application_1/release_Provider.dart';
import 'package:flutter_application_1/disable_Provider.dart';
import '../services/provider_service.dart';
import '../models/provider_model.dart';

class SeeProvider extends StatefulWidget {
  const SeeProvider({super.key});

  @override
  State<SeeProvider> createState() => _SeeProviderState();
}

class _SeeProviderState extends State<SeeProvider> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  late TabController _tabController;

  // Ya no necesitamos estas listas porque Hive maneja el almacenamiento
  // List<Map<String, String>> providers = [];
  // List<Map<String, String>> disabledProviders = [];

  // Inicializar el servicio de Hive
  final ProviderService _providerService = ProviderService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _providerService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    //_providerService.close();
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
            'Proveedores',
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
        Tab(text: "Proveedores"),
        Tab(text: 'Crear Proveedor'),
        Tab(text: 'Proveedores Inhabilitados'),
      ],
    );
  }

  Widget buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        SeeP(key: UniqueKey()),
        Release_Provider(key: UniqueKey()),
        DisableProvider(key: UniqueKey()),
      ],
    );
  }

  // Ya no necesitamos estos métodos porque Hive maneja el almacenamiento directamente
  // void addProvider(Map<String, String> providerData) { ... }
  // void disableProvider(Map<String, String> provider) { ... }
  // void restoreProvider(Map<String, String> provider) { ... }
}