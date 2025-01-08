// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      productId: json['productId'] as String?,
      cartId: json['cartId'] as String?,
      productName: json['productName'] as String?,
      image: json['image'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      size: json['size'] as String? ?? '',
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'size': instance.size,
      'cartId': instance.cartId,
      'totalPrice': instance.totalPrice,
      'productName': instance.productName,
      'image' : instance.image
    };
