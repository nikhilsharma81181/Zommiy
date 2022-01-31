import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/auth_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otp = TextEditingController();
  final _otpKey = GlobalKey<FormState>();
  Timer timer = Timer.periodic(const Duration(milliseconds: 0), (_) {});

  final _firestore = FirebaseFirestore.instance;

  var verificationCode = '';

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String phoneNum = context.watch<AuthModel>().phoneNumber;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.032),
          child: Form(
            key: _otpKey,
            child: Column(
              children: [
                SizedBox(height: height * 0.032),
                Text(
                  'Verify Phone',
                  style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: height * 0.015),
                Text(
                  'code sent to +91-$phoneNum',
                  style: TextStyle(
                    fontSize: width * 0.041,
                  ),
                ),
                SizedBox(height: height * 0.22),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: PinCodeTextField(
                    appContext: (context),
                    autoFocus: true,
                    length: 6,
                    animationType: AnimationType.fade,
                    onChanged: (_) {
                      // context.read<AuthModel>().getOtp(_otp.text);
                    },
                    cursorColor: Palate.primary,
                    controller: _otp,
                    autoDisposeControllers: true,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      activeFillColor: Colors.white,
                      activeColor: Palate.primary,
                      selectedColor: Palate.primary,
                      inactiveColor: Colors.grey,
                      disabledColor: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t recieve code?  ',
                      style: TextStyle(
                        fontSize: width * 0.04,
                      ),
                    ),
                    Text(
                      'Resend now',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Palate.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.017),
                sendButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.14,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Palate.primary,
      ),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: () {
          context.read<AuthModel>().checkOtp(context, _otp.text);
        },
        child: Text(
          'Verify & Proceed',
          style: TextStyle(
            fontSize: width * 0.048,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
