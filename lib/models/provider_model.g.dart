// provider_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model.dart';

class ProviderModelAdapter extends TypeAdapter<ProviderModel> {
  @override
  final int typeId = 1;

  @override
  ProviderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderModel(
      nombre: fields[0] as String?,
      correoElectronico: fields[1] as String?,
      representante: fields[2] as String?,
      rfc: fields[3] as String?,
      direccion: fields[4] as String?,
      telefono: fields[5] as String?,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.correoElectronico)
      ..writeByte(2)
      ..write(obj.representante)
      ..writeByte(3)
      ..write(obj.rfc)
      ..writeByte(4)
      ..write(obj.direccion)
      ..writeByte(5)
      ..write(obj.telefono)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
