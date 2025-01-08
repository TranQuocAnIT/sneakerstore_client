import 'package:json_annotation/json_annotation.dart';
import '../product/product.dart';
import '../user/user.dart';

part 'cart.g.dart';



@JsonSerializable()
class Cart {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "userId")
  String? userId;

  @JsonKey(name: "created_at")
  DateTime? createdAt;

  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  @JsonKey(name: "totalPrice")
  double? totalPrice;
  Cart({
    this.id,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.totalPrice
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}