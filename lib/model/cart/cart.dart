import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class CartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final String size;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.size,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
