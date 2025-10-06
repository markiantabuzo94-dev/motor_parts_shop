part of 'order_bloc.dart';

abstract class OrderEvent {}

class LoadOrders extends OrderEvent {}

class CheckoutEvent extends OrderEvent {}
