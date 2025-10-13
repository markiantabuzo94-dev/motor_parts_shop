import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  @HiveType(typeId: 0, adapterName: 'ProductModelAdapter')
  const factory ProductModel({
    @HiveField(0) required String name,
    @HiveField(1) required String desc,
    @HiveField(2) required int price,
    @HiveField(3) required String image,
    @HiveField(4) required String category,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
