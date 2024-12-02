import 'package:flutter/material.dart';

class DisableClient extends StatefulWidget {
  final List<Map<String, String>> disabledClients;
  final Function(Map<String, String>) onRestoreClient;

const DisableClient({
    super.key, 
    required this.disabledClients,
    required this.onRestoreClient,
  });

  @override
  State<DisableClient> createState() => _DisableClientState();
}

class _DisableClientState extends State<DisableClient> {
  @override
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

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
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Cliente inhabilitado',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48),
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
    List<Map<String, String>> filteredClients = widget.disabledClients
        .where((client) =>
            client['Nombre']!.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2740),
          borderRadius: BorderRadius.circular(30),
        ),
        child: filteredClients.isEmpty
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
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  return buildClientDetails(filteredClients[index]);
                },
              ),
      ),
    );
  }

  Widget buildClientDetails(Map<String, String> client) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E0F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(client['Nombre']!),
        subtitle: Text(client['Correo Electronico']!),
        trailing: IconButton(
          icon: const Icon(Icons.restore),
          onPressed: () => widget.onRestoreClient(client),
        ),
      ),
    );
  }
}
