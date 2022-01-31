import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zommiy/pages/Homepage/homepage.dart';

class AuthModel extends ChangeNotifier {
  String phoneNumber = '';
  var verificationCode = '';

  User? user = FirebaseAuth.instance.currentUser;

  PhoneAuthCredential? _user;

  PhoneAuthCredential get userr => _user!;

  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _firestore = FirebaseFirestore.instance;

  getPhoneNum(String phn) {
    phoneNumber = phn;
    notifyListeners();
  }

  Future signUp(BuildContext context, String phoneNumber) async {
    startTimer();
    var _phoneNumber = '+91' + phoneNumber.trim();
    var verifyPhoneNumber = auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        verificationCompleted: (PhoneAuthCredential) {
          auth.signInWithCredential(PhoneAuthCredential).then((users) async => {
                await _firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .set({
                  'phoneNumber': phoneNumber.trim(),
                  'useruid': auth.currentUser!.uid,
                }, SetOptions(merge: true)).then(
                  (value) => {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const Homepage()),
                      (route) => false,
                    )
                  },
                ),
              });
        },
        verificationFailed: (FirebaseAuthException error) {
          // ignore: avoid_print
          print(error);
        },
        codeSent: (verificationId, [forceResendingToken]) {
          verificationCode = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationCode = verificationId;
        },
        timeout: const Duration(seconds: 60));
    await verifyPhoneNumber;
    notifyListeners();
  }

  Future checkOtp(BuildContext context, String otp) async {
    try {
      await auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode, smsCode: otp))
          .then((user) async => {
                //sign in was success

                await _firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .set({
                  'phonenumber': phoneNumber,
                  'useruid': auth.currentUser!.uid,
                  'admin': false,
                }, SetOptions(merge: true)).then((value) => {
                          //then move to authorised area
                        }),
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Homepage(),
                  ),
                  (route) => false,
                )
              });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    notifyListeners();
  }

  signOut() async {
    auth.signOut();
    notifyListeners();
  }

  int start = 30;
  bool wait = false;

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        timer.cancel();
        start = 30;

        wait = false;
      } else {
        start--;
      }
    });
    notifyListeners();
  }

  Future submitName(BuildContext context, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({
      'name': name,
    });
    Navigator.pop(context);
  }
}
