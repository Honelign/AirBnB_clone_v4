import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/otp_verification.dart';
import 'package:kin_music_player_app/services/network/api/user_service.dart';
import 'package:kin_music_player_app/services/network/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_service.dart';

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  Map user = {"userName": '', "email": ''};
  late String _verificationId;
  late String _fullName;
  UserApiService userApiService = UserApiService();

  Future getUserPrivilege() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("id") ?? "";

    // call api
    var result = await userApiService.fetchUserPrivilege(
        uid: uid, apiEndPoint: "/users");

    // TODO: make id based
    await prefs.remove("prev");
    await prefs.setString("prev", result.toString());

    isLoading = false;
    notifyListeners();

    return true;
  }

  Future register(CustomUser user) async {
    isLoading = true;
    notifyListeners();
    var result = await userApiService.createAccount(user);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future login(email, password) async {
    isLoading = true;
    notifyListeners();
    var result = await userApiService.logIn(email, password);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future googleLogin() async {
    isLoading = true;
    notifyListeners();
    var result = await userApiService.loginWithGoogle();
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future loginFacebook() async {
    const String apiEndPoint = '/redirect';
    isLoading = true;
    notifyListeners();
    // var result = await loginWithFacebook(apiEndPoint);
    isLoading = false;
    return "";
  }

  Future requestOTP(phoneNumber, context, fullName) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) async {
            PhoneAuthCredential local = PhoneAuthProvider.credential(
                verificationId: _verificationId,
                smsCode: phoneAuthCredential.smsCode!);

            signInWithPhoneAuthCredential(local, context);
          },
          verificationFailed: (verificationFailed) async {
            isLoading = false;
            print("@otp" + verificationFailed.message!.toString());
            kShowToast(message: "Please try again!");
          },
          codeSent: (verificationId, resendingToken) async {
            Navigator.pushNamed(context, OTPVerification.routeName);
            _verificationId = verificationId;
            _fullName = fullName;
          },
          // timeout: Duration(seconds: 120),
          codeAutoRetrievalTimeout: (verificationId) async {});
    } catch (e) {
      print("@otp" + e.toString());
      kShowToast(message: "Invalid OTP");
      rethrow;
    }
    isLoading = false;
  }

  Future verifyOTP(code, context) async {
    try {
      isLoading = true;
      notifyListeners();
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);

      signInWithPhoneAuthCredential(
        phoneAuthCredential,
        context,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }

    notifyListeners();
    isLoading = false;
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, context) async {
    try {
      final fbUser =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

      FirebaseAuth.instance.currentUser!.updateDisplayName(_fullName);

      // update user name

      var currentUser = fbUser.user;
      if (currentUser != null) {
        // redirect user to home page
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CustomBottomAppBar()),
            (route) => false);

        // cache user info
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', currentUser!.uid);

        await prefs.setString(
            'email${currentUser!.uid}',
            FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.phoneNumber!
                : "Phone Number");
        notifyListeners();
      } else {
        kShowToast(message: "Invalid OTP");
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      kShowToast(message: "Invalid OTP");
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('token') != null) {
      return true;
    }
    return false;
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id') ?? FirebaseAuth.instance.currentUser?.uid;
    user["userName"] = prefs.getString('name$id') ??
        FirebaseAuth.instance.currentUser!.displayName;
    user["email"] =
        prefs.getString('email$id') ?? FirebaseAuth.instance.currentUser!.email;
    return user;
  }

  logOut() async {
    // logout firebase
    await FirebaseAuth.instance.signOut();

    // logout google sign in
    try {
      final googleSignIn = GoogleSignIn();
      googleSignIn.signOut();
    } catch (e) {}

    // clear cache stored user info
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString('id');
    pref.remove('id');
    pref.remove('name$id');
    pref.remove('email$id');
  }
}
