import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatelessWidget {
  final Map<String, String> client;

  const ClientDetailsScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8470A1), // Background color of the screen
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detalles del Cliente',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2F2740),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: const Color(0xFF2F2740),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_circle, color: Colors.white, size: 40),
                  const SizedBox(width: 10),
                  const Text(
                    'Nombre ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    client['Nombre'] ?? 'Nombre no disponible',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildClientDetail(
                    'RFC: \n',
                    client['RFC'],
                  ),
                  buildClientDetail('Telefono: \n', client['Telefono']),
                ],
              ),
              const SizedBox(height: 5), // Espacio entre filas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildClientDetail(
                      'Correo Electronico: \n', client['Correo Electronico']),
                  buildClientDetail('Dirección: \n ', client['Direccion']),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClientDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label ${value ?? 'No disponible'}',
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
