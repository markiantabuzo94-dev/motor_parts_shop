part of 'cart_bloc.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Map<String, dynamic> product;
  AddToCartEvent(this.product);
}

class RemoveFromCartEvent extends CartEvent {
  final String productName;
  RemoveFromCartEvent(this.productName);
}

class ClearCartEvent extends CartEvent {}
