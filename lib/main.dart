import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/client_model.dart';
import 'models/provider_model.dart';
import 'models/project_model.dart';  // Añadir esta importación
import 'custom_screen.dart';
import 'see_Client.dart';

void main() async {
  try {
    print('1. Iniciando aplicación');
    WidgetsFlutterBinding.ensureInitialized();
    print('2. Flutter Binding inicializado');
    
    await Hive.initFlutter();
    print('3. Hive inicializado');
    
    // Registro del adaptador de Cliente
    if (!Hive.isAdapterRegistered(0)) {
      print('4. Registrando adapter de Cliente');
      Hive.registerAdapter(ClientModelAdapter());
      print('5. Adapter de Cliente registrado');
    } else {
      print('4. Adapter de Cliente ya estaba registrado');
    }

    // Registro del adaptador de Proveedor
    if (!Hive.isAdapterRegistered(1)) {
      print('6. Registrando adapter de Proveedor');
      Hive.registerAdapter(ProviderModelAdapter());
      print('7. Adapter de Proveedor registrado');
    } else {
      print('6. Adapter de Proveedor ya estaba registrado');
    }

    // Registro del adaptador de Proyecto
    if (!Hive.isAdapterRegistered(2)) {
      print('8. Registrando adapter de Proyecto');
      Hive.registerAdapter(ProjectModelAdapter());
      print('9. Adapter de Proyecto registrado');
    } else {
      print('8. Adapter de Proyecto ya estaba registrado');
    }
    
    // Abrir las boxes
    final clientBox = await Hive.openBox<ClientModel>('clients');
    print('10. Box de clientes abierta: ${clientBox.name}');
    print('11. Box de clientes contiene ${clientBox.length} elementos');

    final providerBox = await Hive.openBox<ProviderModel>('providers');
    print('12. Box de proveedores abierta: ${providerBox.name}');
    print('13. Box de proveedores contiene ${providerBox.length} elementos');

    final projectBox = await Hive.openBox<ProjectModel>('projects');
    print('14. Box de proyectos abierta: ${projectBox.name}');
    print('15. Box de proyectos contiene ${projectBox.length} elementos');
    
    runApp(const MyApp());
    print('16. App iniciada');
  } catch (e, stackTrace) {
    print('Error en inicialización:');
    print(e);
    print('Stack trace:');
    print(stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScreen(),
    );
  }
}