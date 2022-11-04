// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 0;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products(
      audio: fields[18] as String?,
      banner: fields[19] as String?,
      id: fields[0] as int?,
      price: fields[1] as int?,
      productId: fields[2] as int?,
      title: fields[3] as String?,
      body: fields[7] as String?,
      intro: fields[4] as String?,
      name: fields[5] as String?,
      order: fields[8] as int?,
      status: fields[6] as int?,
      traingName: fields[9] as String?,
      albumTitle: fields[10] as String?,
      lectureTitle: fields[11] as String?,
      audioCount: fields[14] as int?,
      isBought: fields[12] as bool?,
      trainingBanner: fields[17] as String?,
    )
      ..played = fields[13] as bool?
      ..position = fields[15] as int?
      ..duration = fields[16] as int?;
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.intro)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.body)
      ..writeByte(8)
      ..write(obj.order)
      ..writeByte(9)
      ..write(obj.traingName)
      ..writeByte(10)
      ..write(obj.albumTitle)
      ..writeByte(11)
      ..write(obj.lectureTitle)
      ..writeByte(12)
      ..write(obj.isBought)
      ..writeByte(13)
      ..write(obj.played)
      ..writeByte(14)
      ..write(obj.audioCount)
      ..writeByte(15)
      ..write(obj.position)
      ..writeByte(16)
      ..write(obj.duration)
      ..writeByte(17)
      ..write(obj.trainingBanner)
      ..writeByte(18)
      ..write(obj.audio)
      ..writeByte(19)
      ..write(obj.banner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
