// lib/models/cart_item.dart
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  void increaseQuantity() {
    quantity++;
  }

  // Minimal 1, remove diurus cart_model
  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  double get totalPrice => product.price * quantity;

  // Untuk order summary di checkout
  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}