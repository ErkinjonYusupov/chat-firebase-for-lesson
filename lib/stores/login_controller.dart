import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
  bool loading = false;
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  login_() async {
    try {
      if (loading) return;
      loading = true;
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: login.text, password: password.text);
      firestore.collection('users').doc(userCredential.user!.uid).set(
          {"uid": userCredential.user!.uid, "email": login.text},
          SetOptions(merge: true));
    } catch (err) {
      Get.rawSnackbar(message: err.toString());
    } finally {
      loading = false;
      update();
    }
  }

  createAccount() async {
    try {
      if (loading) return;
      loading = true;
      if (password.text != confirmPassword.text) {
        Get.rawSnackbar(
            message: "Parolni tasdiqlashda xato",
            snackPosition: SnackPosition.TOP);
        return;
      }
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: login.text, password: password.text);
      firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({"uid": userCredential.user!.uid, "email": login.text});
    } catch (err) {
      Get.rawSnackbar(message: err.toString());
    } finally {
      loading = false;
      update();
    }
  }


  logOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}