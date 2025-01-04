import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order.g.dart';


@JsonSerializable()
class Order {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "userId")
  String? userId;

  @JsonKey(name: "productId")
  String? productId;

  @JsonKey(name: "productName")
  String? productName;

  @JsonKey(name: "productImage")
  String? productImage;

  @JsonKey(name: "size")
  String? size;

  @JsonKey(name: "color")
  String? color;

  @JsonKey(name: "quantity")
  int? quantity;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "totalPrice")
  double? totalPrice;

  @JsonKey(name: "customerName")
  String? customerName;

  @JsonKey(name: "phoneNumber")
  String? phoneNumber;

  @JsonKey(name: "address")
  String? address;

  @JsonKey(name: "orderDate")
  DateTime? orderDate;

  Order({
    this.id,
    this.userId,
    this.productId,
    this.productName,
    this.productImage,
    this.size,
    this.color,
    this.quantity,
    this.price,
    this.totalPrice,
    this.customerName,
    this.phoneNumber,
    this.address,
    this.orderDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}