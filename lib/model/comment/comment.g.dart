// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      image: json['image'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      message: json['message'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      orderId: json['orderId'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'productId': instance.productId,
      'orderId': instance.orderId,
      'productName': instance.productName,
      'totalPrice': instance.totalPrice,
      'image': instance.image,
      'message': instance.message,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
