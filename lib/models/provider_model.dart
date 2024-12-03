import 'package:hive/hive.dart';

part 'provider_model.g.dart';

@HiveType(typeId: 1)
class ProviderModel extends HiveObject {
  @HiveField(0)
  String? nombre;

  @HiveField(1)
  String? correoElectronico;

  @HiveField(2)
  String? representante;

  @HiveField(3)
  String? rfc;

  @HiveField(4)
  String? direccion;

  @HiveField(5)
  String? telefono;

  @HiveField(6)
  bool isActive;

  ProviderModel({
    this.nombre,
    this.correoElectronico,
    this.representante,
    this.rfc,
    this.direccion,
    this.telefono,
    this.isActive = true,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      nombre: map['Nombre'],
      correoElectronico: map['Correo Electronico'],
      representante: map['Representante'],
      rfc: map['RFC'],
      direccion: map['Direccion'],
      telefono: map['Telefono'],
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Nombre': nombre,
      'Correo Electronico': correoElectronico,
      'Representante': representante,
      'RFC': rfc,
      'Direccion': direccion,
      'Telefono': telefono,
      'isActive': isActive,
    };
  }
}