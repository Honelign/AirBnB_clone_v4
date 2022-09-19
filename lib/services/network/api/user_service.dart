import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  Future<String> fetchUserPrivilege(
      {required String uid, required String apiEndPoint}) async {
    try {
      // make api call
      Response response =
          await get(Uri.parse("$kinProfileBaseUrl$apiEndPoint/$uid"));

      // check response code
      if (response.statusCode == 200) {
        var item = jsonDecode(response.body);

        return item['privilege'].toString();
      }

      // return value
    } catch (e) {
      print("@@@ api_service fetchUserPrivilege  $e");
    }
    return "-1";
  }

  // Email and Password Register
  Future<String> createAccount(user) async {
    try {
      // try firebase auth call
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email.toString(),
        password: user.password.toString(),
      );
      var currentUser = await FirebaseAuth.instance.currentUser!;
      // update user name
      currentUser.updateDisplayName(
        user.name.toString(),
      );

      // save some info to cache -> shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', currentUser.uid);
      await prefs.setString(
          'name${currentUser.uid}', currentUser.displayName ?? "");
      await prefs.setString('email${currentUser.uid}', currentUser.email ?? "");

      return "Successfully Registered";
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use" ||
          e.code == "email-already-exists") {
        return "Email already registered";
      } else if (e.code == "invalid-display-name") {
        return "Invalid Full Name";
      } else if (e.code == "invalid-email") {
        return "Email in use";
      } else if (e.code == "invalid-password" || e.code == "weak-password") {
        return "Weak Password";
      } else {
        print(
          "@@api_service + " + e.toString(),
        );
        return "Something went wrong";
      }
    } catch (e) {
      return 'Unknown Error Occurred';
    }
  }

  // Email and Password Register
  Future logIn(email, password) async {
    try {
      // connect with firebase
      var possibleUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (possibleUser.user != null) {
        var currentUser = possibleUser.user;

        // cache user info
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', currentUser!.uid);
        await prefs.setString(
            'name${currentUser.uid}', currentUser.displayName ?? "");
        await prefs.setString(
            'email${currentUser.uid}', currentUser.email ?? "");
      }

      return "Successfully Logged In";
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password" || e.code == "user-not-found") {
        return "Invalid Credentials";
      } else if (e.code == "invalid-email") {
        print("@@api_service + " + e.code);
        return "Something Went Wrong";
      }
    } catch (e) {
      print("@@api_service" + e.toString());
      print("@@api_service + " + e.toString());
      return "Something Went Wrong";
    }
  }

  // TODO:Implement
  Future loginWithFacebook(apiEndPoint) async {}

  // Google Sign in Function
  Future loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      GoogleSignInAccount? _user;

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var fbUser = await FirebaseAuth.instance.signInWithCredential(credential);
      var currentUser = fbUser.user!;
      // cache user info
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', currentUser.uid);
      await prefs.setString(
          'name${currentUser.uid}', currentUser.displayName ?? "");
      await prefs.setString('email${currentUser.uid}', currentUser.email ?? "");

      return "Successfully Logged In";
    } catch (e) {
      print("@api_service -> loginWithGoogle error - " + e.toString());
      return e.toString();
    }
  }
}
