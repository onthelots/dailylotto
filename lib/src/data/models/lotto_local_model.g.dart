// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotto_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LottoLocalModelAdapter extends TypeAdapter<LottoLocalModel> {
  @override
  final int typeId = 0;

  @override
  LottoLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LottoLocalModel(
      round: fields[0] as int,
      entries: (fields[1] as List).cast<LottoEntry>(),
      timeStamp: fields[3] as DateTime,
      winningNumbers: (fields[2] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, LottoLocalModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.round)
      ..writeByte(1)
      ..write(obj.entries)
      ..writeByte(2)
      ..write(obj.winningNumbers)
      ..writeByte(3)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LottoLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LottoEntryAdapter extends TypeAdapter<LottoEntry> {
  @override
  final int typeId = 1;

  @override
  LottoEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LottoEntry(
      date: fields[0] as String,
      numbers: (fields[1] as List).cast<int>(),
      recommendReason: fields[2] as String,
      dailyTip: fields[3] as String,
      result: fields[4] as String?,
      isDefault: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LottoEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.numbers)
      ..writeByte(2)
      ..write(obj.recommendReason)
      ..writeByte(3)
      ..write(obj.dailyTip)
      ..writeByte(4)
      ..write(obj.result)
      ..writeByte(5)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LottoEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
