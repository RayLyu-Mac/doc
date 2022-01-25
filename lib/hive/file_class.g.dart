// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class monitoringdocAdapter extends TypeAdapter<monitoring_doc> {
  @override
  final int typeId = 0;

  @override
  monitoring_doc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return monitoring_doc(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, monitoring_doc obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mon_docN)
      ..writeByte(2)
      ..write(obj.doc_time)
      ..writeByte(3)
      ..write(obj.pr_serial);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is monitoringdocAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class rdAdapter extends TypeAdapter<rd> {
  @override
  final int typeId = 1;

  @override
  rd read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return rd(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, rd obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.rname)
      ..writeByte(1)
      ..write(obj.rdoc_num)
      ..writeByte(2)
      ..write(obj.rdoc_time)
      ..writeByte(3)
      ..write(obj.ra_serial);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is rdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
