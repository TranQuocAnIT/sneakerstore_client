import 'package:json_annotation/json_annotation.dart';
part 'cartitem.g.dart';
@JsonSerializable()
class CartItem {
  @JsonKey(name: "productId")
  String? productId;

  @JsonKey(name: "quantity")
  int quantity;

  @JsonKey(name: "size")
  String size;

  @JsonKey(name: "cartId")
  String? cartId;

  @JsonKey(name: "totalPrice")
  double? totalPrice;

  @JsonKey(name: "productName")
  String? productName;

  @JsonKey(name: "image")
  String? image;

  CartItem({
    this.productId,
    this.cartId,
    this.totalPrice,
    this.productName,
    this.quantity = 1,
    this.size = '',
    this.image
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}