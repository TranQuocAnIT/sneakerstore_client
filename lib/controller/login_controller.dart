import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:sneakerstore_client/model/user/user.dart';
import 'package:sneakerstore_client/pages/home_page.dart';

import '../pages/login_page.dart';


class LoginController extends GetxController {
  final box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  // Khai báo User? để có thể null
  User? LoginUser;
  String? currentUserId;

  TextEditingController signupNameCtrl = TextEditingController();
  TextEditingController signupPhoneNumberCtrl = TextEditingController();
  TextEditingController signinPhoneNumberCtrl = TextEditingController();
  TextEditingController signupPasswordCtrl = TextEditingController();
  TextEditingController signinPasswordCtrl = TextEditingController();
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEntered;

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    // Kiểm tra và load thông tin user từ storage khi khởi tạo
    loadUserFromStorage();
    super.onInit();
  }

  // Thêm phương thức loadUserFromStorage
  void loadUserFromStorage() {
    try {
      final userData = box.read('signinUser');
      if (userData != null) {
        LoginUser = User.fromJson(userData as Map<String, dynamic>);
        currentUserId = LoginUser?.id;
        update(); // Cập nhật UI
      }
    } catch (e) {
      print('Lỗi khi load thông tin user: $e');
      // Xóa dữ liệu không hợp lệ
      box.remove('signinUser');
    }
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
        otpFieldShown = false;
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
        Get.snackbar('Thành công ' , 'Mã OTP của bạn là $otp ', colorText: Colors.green);
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
      try {
        var querySnapshot = await userCollection
            .where('phonenumber', isEqualTo: int.tryParse(phonenumber))
            .where('password', isEqualTo: password)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;

          // Lưu vào storage
          box.write('signinUser', userData);

          // Cập nhật biến trong controller
          LoginUser = User.fromJson(userData);
          currentUserId = LoginUser?.id;

          // Clear controllers
          signinPhoneNumberCtrl.clear();
          signinPasswordCtrl.clear();

          update(); // Cập nhật UI

          Get.snackbar(
              'Thành công',
              'Đăng nhập thành công',
              colorText: Colors.green
          );
          Get.offAll(() => const HomePage());
        } else {
          Get.snackbar(
              'Lỗi',
              'Tài khoản hoặc mật khẩu không chính xác',
              colorText: Colors.red
          );
        }
      } catch (e) {
        print('Lỗi đăng nhập: $e');
        Get.snackbar(
            'Lỗi',
            'Đã xảy ra lỗi khi đăng nhập',
            colorText: Colors.red
        );
      }
    } else {
      Get.snackbar(
          'Cảnh báo',
          'Hãy nhập đầy đủ số điện thoại và mật khẩu',
          colorText: Colors.red
      );
    }
  }


  // Thêm phương thức logout
  Future<void> logout() async  {
    box.remove('signinUser');
    LoginUser = null;
    currentUserId = null;
    update();
    Get.offAll(() => const LoginPage());
    Get.snackbar(
        'Thông báo',
        'Đã đăng xuất thành công',
        colorText: Colors.green
    );
  }

  Future<void> updateUserProfile(User? updatedUser) async {
    if (updatedUser != null) {
      try {
        await userCollection.doc(updatedUser.id).update(updatedUser.toJson());
        box.write('signinUser', updatedUser.toJson()); // Save updated user to storage
        Get.snackbar('Success', 'Profile updated successfully');
        update();
      } catch (e) {
        Get.snackbar('Error', 'Failed to update profile: $e');
        print('Error updating profile: $e');
      }
    }
  }

  // Update profile picture
  void updateProfilePicture(String imageUrl) {
    if (LoginUser != null) {
      LoginUser!.profilePicture = imageUrl;
      updateUserProfile(LoginUser);
    }
  }


  // Kiểm tra trạng thái đăng nhập
  bool get isLoggedIn => LoginUser != null;
}