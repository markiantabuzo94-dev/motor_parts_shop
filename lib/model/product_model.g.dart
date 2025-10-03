// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<_$ProductModelImpl> {
  @override
  final int typeId = 0;

  @override
  _$ProductModelImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$ProductModelImpl(
      name: fields[0] as String,
      desc: fields[1] as String,
      price: fields[2] as int,
      image: fields[3] as String,
      category: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _$ProductModelImpl obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.desc)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      name: json['name'] as String,
      desc: json['desc'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'desc': instance.desc,
      'price': instance.price,
      'image': instance.image,
      'category': instance.category,
    };
