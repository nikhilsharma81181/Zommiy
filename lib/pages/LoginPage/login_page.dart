import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/auth_model.dart';

import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Palate.primary,
      bottomSheet: Container(
        width: width,
        color: Palate.primary,
        child: SingleChildScrollView(
          reverse: true,
          child: SizedBox(
            height: height,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width,
                    alignment: Alignment.centerRight,
                    child: Image(
                      width: width * 0.95,
                      image: const AssetImage('assets/images/thai_food.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(width * 0.027),
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Namaste!',
                          style: TextStyle(
                            fontSize: width * 0.076,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: height * 0.002),
                        Text(
                          'Get started please enter your name & number',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: width * 0.08),
                        buildTextFeild(),
                        SizedBox(height: width * 0.05),
                        sendButton(),
                        SizedBox(height: width * 0.07),
                      ],
                    ),
                  ),
                ],
              ),
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
        color: Colors.black,
      ),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: () {
          context.read<AuthModel>().signUp(context, _phoneController.text);
          context.read<AuthModel>().getPhoneNum(_phoneController.text);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const OtpPage()));
        },
        child: Text(
          'Send OTP',
          style: TextStyle(
            fontSize: width * 0.048,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildTextFeild() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.13,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: width * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: width * 0.07,
                    height: width * 0.056,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/india.png'),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(width: width * 0.01),
                  Text(
                    '+91',
                    style: TextStyle(
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: width * 0.05),
          SizedBox(
            width: width * 0.67,
            child: TextFormField(
              cursorColor: Colors.red.withOpacity(0.8),
              keyboardType: TextInputType.number,
              maxLength: 10,
              style: TextStyle(
                fontSize: width * 0.046,
                fontWeight: FontWeight.w500,
              ),
              controller: _phoneController,
              autofocus: true,
              onChanged: (_) {},
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                counterText: '',
                hintText: 'Enter Phone Number',
                hintStyle: TextStyle(
                  fontSize: width * 0.042,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
