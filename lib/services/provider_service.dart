import 'package:hive_flutter/hive_flutter.dart';
import '../models/provider_model.dart';

class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  static const String boxName = 'providers';
  Box<ProviderModel>? _box;

  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<ProviderModel>(boxName);
    }
  }

  Box<ProviderModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw StateError('Box not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> addProvider(ProviderModel provider) async {
    await init();
    await box.add(provider);
  }

  List<ProviderModel> getActiveProviders() {
    try {
      return box.values.where((provider) => provider.isActive).toList();
    } catch (e) {
      print('Error en getActiveProviders: $e');
      return [];
    }
  }

  List<ProviderModel> getDisabledProviders() {
    try {
      return box.values.where((provider) => !provider.isActive).toList();
    } catch (e) {
      print('Error en getDisabledProviders: $e');
      return [];
    }
  }

  Future<void> updateProvider(int index, ProviderModel provider) async {
    await init();
    await box.putAt(index, provider);
  }

  Future<void> disableProvider(int index) async {
    await init();
    ProviderModel? provider = box.getAt(index);
    if (provider != null) {
      provider.isActive = false;
      await box.putAt(index, provider);
    }
  }

  Future<void> restoreProvider(int index) async {
    await init();
    ProviderModel? provider = box.getAt(index);
    if (provider != null) {
      provider.isActive = true;
      await box.putAt(index, provider);
    }
  }

  int? getProviderIndex(ProviderModel targetProvider) {
    try {
      return box.values.toList().indexWhere((provider) =>
        provider.nombre == targetProvider.nombre &&
        provider.correoElectronico == targetProvider.correoElectronico &&
        provider.telefono == targetProvider.telefono
      );
    } catch (e) {
      print('Error en getProviderIndex: $e');
      return null;
    }
  }

  List<ProviderModel> searchProviders(String query) {
    try {
      return box.values.where((provider) => 
        provider.isActive &&
        (provider.nombre?.toLowerCase().contains(query.toLowerCase()) ?? false ||
        (provider.correoElectronico?.toLowerCase() ?? '').contains(query.toLowerCase()))
      ).toList();
    } catch (e) {
      print('Error en searchProviders: $e');
      return [];
    }
  }
}