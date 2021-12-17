import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../notes/presentation/home/home_page.dart';
import 'package:get/get.dart';

import '../../../../routing/app_pages.dart';
import '../../domain/usecases/login_use_case.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final storage = new FlutterSecureStorage();
  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      if (googleSignInAccount != null) {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        Get.offNamed(Routes.HOME);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (builder) => HomePage()),
        //     (route) => false);

        final snackBar =
            SnackBar(content: Text(userCredential.user.displayName));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print("here---->");
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> signOut({BuildContext context}) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
