import 'package:flutter_bloc/flutter_bloc.dart';
import '../../hive_service/hive_service.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCart>((event, emit) {
      final cart = HiveService.getCart();
      emit(CartLoaded(cart));
    });

    on<AddToCartEvent>((event, emit) async {
      await HiveService.addToCart(event.product);
      final cart = HiveService.getCart();
      emit(CartLoaded(cart));
    });

    on<RemoveFromCartEvent>((event, emit) async {
      await HiveService.removeFromCart(event.productName);
      final cart = HiveService.getCart();
      emit(CartLoaded(cart));
    });

    on<ClearCartEvent>((event, emit) async {
      await HiveService.clearCart();
      emit(CartLoaded([]));
    });
  }
}
