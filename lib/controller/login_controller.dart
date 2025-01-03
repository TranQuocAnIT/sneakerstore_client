import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:sneakerstore_client/model/user/user.dart';

class LoginController extends GetxController{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController signupNameCtrl = TextEditingController();
  TextEditingController signupPhoneNumberCtrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }
  addUser(){
    try {
      if(signupNameCtrl.text.isEmpty || signupPhoneNumberCtrl.text.isEmpty)
        {
          Get.snackbar('lưu ý' , 'Hãy điền đầu đủ trường ', colorText: Colors.amber);
          return;
        }
      DocumentReference doc = userCollection.doc();
      User user = User(
        id:doc.id,
        name: signupNameCtrl.text,
        phonenumber: int.parse(signupPhoneNumberCtrl.text),
      );
       final userJson = user.toJson();
       doc.set(userJson);
       Get.snackbar('Thành Công' , 'Thêm tài khoản thành công', colorText: Colors.green);

    } catch (e) {
      Get.snackbar('Lổi' ,e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  senderOtp(){
    try {
      final random = Random();
      int otp = random.nextInt(9000);
      print(otp);
      // neu gửi otp thành công hiển thị thông báo
      if(otp != null)
        {
          otpFieldShown = true;
          Get.snackbar('Thành công ' , 'Mã OTP đã được gửi đi', colorText: Colors.green);
        }else{
        Get.snackbar('Lổi' , 'Mã OTP chưa được gửi đi', colorText: Colors.red);
      }
    } catch (e) {
      print(e);
    }finally{
      update();
    }
   }
}