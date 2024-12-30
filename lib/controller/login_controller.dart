import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:sneakerstore_client/model/user/user.dart';
import 'package:sneakerstore_client/pages/home_page.dart';

class LoginController extends GetxController{

  final box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController signupNameCtrl = TextEditingController();
  TextEditingController signupPhoneNumberCtrl = TextEditingController();

  TextEditingController signinPhoneNumberCtrl = TextEditingController();
  TextEditingController signupPasswordCtrl = TextEditingController();
  TextEditingController signinPasswordCtrl = TextEditingController();
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEntered;
  User? LoginUser;

  @override
  void onReady() {
    super.onReady();
    Map<String,dynamic> user = box.read('signinUser');
    if(user !=null){
      LoginUser = User.fromJson(user);
      Get.to(const HomePage());
    }else{

    }
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }
  addUser(){
    try {
     if(otpSend == otpEntered){
       DocumentReference doc = userCollection.doc();
       User user = User(
         id:doc.id,
         name: signupNameCtrl.text,
         phonenumber: int.parse(signupPhoneNumberCtrl.text),
         password: signupPasswordCtrl.text, // Lưu mật khẩu
       );
       final userJson = user.toJson();
       doc.set(userJson);
       Get.snackbar('Thành Công' , 'Thêm tài khoản thành công', colorText: Colors.green);
       signupPhoneNumberCtrl.clear();
       signupNameCtrl.clear();
       signupPasswordCtrl.clear();
       otpController.clear();
     }else
       {
         Get.snackbar('Lổi ' , 'mã OPT không chính xác', colorText: Colors.green);
       }

    } catch (e) {
      Get.snackbar('Lổi' ,e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  senderOtp(){
    try {
      if(signupNameCtrl.text.isEmpty || signupPhoneNumberCtrl.text.isEmpty)
      {
        Get.snackbar('lưu ý' , 'Hãy điền đầu đủ trường ', colorText: Colors.amber);
        return;
      }
      final random = Random();
      int otp = random.nextInt(9000);
      print(otp);
      // neu gửi otp thành công hiển thị thông báo
      if(otp != null)
        {
          otpFieldShown = true;
          otpSend = otp;
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
  Future<void> loginWithPhoneAndPassword() async {
    String phonenumber = signinPhoneNumberCtrl.text;
    String password = signinPasswordCtrl.text;

    if (phonenumber.isNotEmpty && password.isNotEmpty) {
      var querySnapshot = await userCollection
          .where('phonenumber', isEqualTo: int.tryParse(phonenumber))
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        var userData = userDoc.data() as Map<String, dynamic>;
        box.write('signinUser', userData);
        signinPhoneNumberCtrl.clear();
        signinPasswordCtrl.clear();
        Get.to(HomePage());
        Get.snackbar('Thành công', 'Đăng nhập thành công', colorText: Colors.green);
      } else {
        Get.snackbar('Lỗi', 'Tài khoản hoặc mật khẩu không chính xác', colorText: Colors.red);
      }
    } else {
      Get.snackbar('Cảnh báo', 'Hãy nhập đầy đủ số điện thoại và mật khẩu', colorText: Colors.red);
    }
  }
   }
