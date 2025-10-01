import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String desc;

  @HiveField(2)
  int price;

  @HiveField(3)
  String image;

  @HiveField(4)
  String category;

  ProductModel({
    required this.name,
    required this.desc,
    required this.price,
    required this.image,
    required this.category,
  });
}
