// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  @HiveField(0)
  String get name => throw _privateConstructorUsedError;
  @HiveField(1)
  String get desc => throw _privateConstructorUsedError;
  @HiveField(2)
  int get price => throw _privateConstructorUsedError;
  @HiveField(3)
  String get image => throw _privateConstructorUsedError;
  @HiveField(4)
  String get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
    ProductModel value,
    $Res Function(ProductModel) then,
  ) = _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call({
    @HiveField(0) String name,
    @HiveField(1) String desc,
    @HiveField(2) int price,
    @HiveField(3) String image,
    @HiveField(4) String category,
  });
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? desc = null,
    Object? price = null,
    Object? image = null,
    Object? category = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            desc: null == desc
                ? _value.desc
                : desc // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
    _$ProductModelImpl value,
    $Res Function(_$ProductModelImpl) then,
  ) = __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String name,
    @HiveField(1) String desc,
    @HiveField(2) int price,
    @HiveField(3) String image,
    @HiveField(4) String category,
  });
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
    _$ProductModelImpl _value,
    $Res Function(_$ProductModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? desc = null,
    Object? price = null,
    Object? image = null,
    Object? category = null,
  }) {
    return _then(
      _$ProductModelImpl(
        name: null == name ? _value.name : name as String,
        desc: null == desc ? _value.desc : desc as String,
        price: null == price ? _value.price : price as int,
        image: null == image ? _value.image : image as String,
        category: null == category ? _value.category : category as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0, adapterName: 'ProductModelAdapter')
class _$ProductModelImpl with DiagnosticableTreeMixin implements _ProductModel {
  const _$ProductModelImpl({
    @HiveField(0) required this.name,
    @HiveField(1) required this.desc,
    @HiveField(2) required this.price,
    @HiveField(3) required this.image,
    @HiveField(4) required this.category,
  });

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @HiveField(0)
  final String name;
  @override
  @HiveField(1)
  final String desc;
  @override
  @HiveField(2)
  final int price;
  @override
  @HiveField(3)
  final String image;
  @override
  @HiveField(4)
  final String category;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductModel(name: $name, desc: $desc, price: $price, image: $image, category: $category)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductModel'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('desc', desc))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('category', category));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, desc, price, image, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(this);
  }
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel({
    @HiveField(0) required final String name,
    @HiveField(1) required final String desc,
    @HiveField(2) required final int price,
    @HiveField(3) required final String image,
    @HiveField(4) required final String category,
  }) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @HiveField(0)
  String get name;
  @override
  @HiveField(1)
  String get desc;
  @override
  @HiveField(2)
  int get price;
  @override
  @HiveField(3)
  String get image;
  @override
  @HiveField(4)
  String get category;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
