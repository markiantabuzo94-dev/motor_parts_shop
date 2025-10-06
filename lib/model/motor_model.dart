import 'package:hive/hive.dart';

class MotorModel {
  String name;
  int price;
  String image;

  MotorModel({required this.name, required this.price, required this.image});
}

class MotorModelAdapter extends TypeAdapter<MotorModel> {
  @override
  final int typeId = 0;

  @override
  MotorModel read(BinaryReader reader) {
    return MotorModel(
      name: reader.readString(),
      price: reader.readInt(),
      image: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MotorModel obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.price);
    writer.writeString(obj.image);
  }
}
