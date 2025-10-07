import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive_service/hive_service.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<LoadOrders>((event, emit) {
      final orders = HiveService.getOrders();
      emit(OrderLoaded(orders));
    });

    on<CheckoutEvent>((event, emit) async {
      await HiveService.checkout();
      final orders = HiveService.getOrders();
      emit(OrderLoaded(orders));
    });
  }
}
