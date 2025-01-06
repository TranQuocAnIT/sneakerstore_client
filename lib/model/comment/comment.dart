import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "customerId")
  String? customerId;

  @JsonKey(name: "customerName")
  String? customerName;

  @JsonKey(name: "productId")
  String? productId;

  @JsonKey(name: "orderId")
  String? orderId;

  @JsonKey(name: "productName")
  String? productName;

  @JsonKey(name: "totalPrice")
  double? totalPrice;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "message")
  String? message ;

  @JsonKey(name: "createdAt")
  DateTime? createdAt ;



  Comment({
    this.id,
    this.customerId,
    this.customerName,
    this.image,
    this.productId,
    this.productName,
    this.totalPrice,
    this.message,
    this.createdAt,
    this.orderId ,


  });

  // Factory method for JSON deserialization
  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
