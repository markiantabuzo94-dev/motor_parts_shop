part of 'order_bloc.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Map<String, dynamic>> orders;
  OrderLoaded(this.orders);
}
