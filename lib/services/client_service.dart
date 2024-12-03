import 'package:hive_flutter/hive_flutter.dart';
import '../models/client_model.dart';

class ClientService {
  static final ClientService _instance = ClientService._internal();
  factory ClientService() => _instance;
  ClientService._internal();

  static const String boxName = 'clients';
  Box<ClientModel>? _box;

  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<ClientModel>(boxName);
    }
  }

  Box<ClientModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw StateError('Box not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> addClient(ClientModel client) async {
    await init();
    await box.add(client);
  }

  List<ClientModel> getActiveClients() {
    try {
      return box.values.where((client) => client.isActive).toList();
    } catch (e) {
      print('Error en getActiveClients: $e');
      return [];
    }
  }

  List<ClientModel> getDisabledClients() {
    try {
      return box.values.where((client) => !client.isActive).toList();
    } catch (e) {
      print('Error en getDisabledClients: $e');
      return [];
    }
  }

  Future<void> updateClient(int index, ClientModel client) async {
    await init();
    await box.putAt(index, client);
  }

  Future<void> disableClient(int index) async {
    await init();
    ClientModel? client = box.getAt(index);
    if (client != null) {
      client.isActive = false;
      await box.putAt(index, client);
    }
  }

  Future<void> restoreClient(int index) async {
    await init();
    ClientModel? client = box.getAt(index);
    if (client != null) {
      client.isActive = true;
      await box.putAt(index, client);
    }
  }

  int? getClientIndex(ClientModel targetClient) {
    try {
      return box.values.toList().indexWhere((client) =>
        client.nombre == targetClient.nombre &&
        client.correoElectronico == targetClient.correoElectronico &&
        client.telefono == targetClient.telefono
      );
    } catch (e) {
      print('Error en getClientIndex: $e');
      return null;
    }
  }

  List<ClientModel> searchClients(String query) {
    try {
      return box.values.where((client) => 
        client.isActive &&
        (client.nombre?.toLowerCase().contains(query.toLowerCase()) ?? false ||
        (client.correoElectronico?.toLowerCase() ?? '').contains(query.toLowerCase()))
      ).toList();
    } catch (e) {
      print('Error en searchClients: $e');
      return [];
    }
  }
}