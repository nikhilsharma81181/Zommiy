import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/auth_model.dart';
import 'package:zommiy/pages/Gift/gift.dart';
import 'package:zommiy/pages/Qr_code/scanner.dart';
import 'package:zommiy/pages/Restaurant/cart.dart';
import 'package:zommiy/pages/Restaurant/restaurant_detail.dart';
import 'package:zommiy/pages/Search/search.dart';
import 'package:zommiy/pages/User/user.dart';

import 'home.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  Timer timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {});

  @override
  void initState() {
    super.initState();
    getName();
  }

  getName() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      if (!value.data()!.containsKey('name')) {
        timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const NameDialog()),
          );
          timer.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List pages = [
    const Home(),
    const Search(),
    const Gift(),
    const User(),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          pages[_selectedIndex],
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: width,
                  height: width * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildIcon(0, width * 0.068, width * 0.068, 'Home'),
                      buildIcon(1, width * 0.065, width * 0.065, 'Search'),
                      qrButton(),
                      buildIcon(2, width * 0.068, width * 0.068, 'Gift'),
                      buildIcon(3, width * 0.068, width * 0.068, 'User'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget qrButton() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.147,
      height: width * 0.147,
      child: RawMaterialButton(
        elevation: 14,
        fillColor: Palate.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Scanner()));
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const RestaurantDetails()));
        },
        child: Icon(
          Icons.qr_code,
          color: Colors.white,
          size: width * 0.085,
        ),
      ),
    );
  }

  Widget buildIcon(int index, double width, height, svg) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: _selectedIndex == index
          ? SizedBox(
              width: width * 0.085,
              child: SvgPicture.asset(
                'assets/icons/${svg}B.svg',
                height: width * 0.08,
                width: width * 0.08,
                color: Palate.primary,
              ),
            )
          : SizedBox(
              width: width * 0.085,
              child: SvgPicture.asset(
                'assets/icons/${svg}N.svg',
                height: height,
                width: width,
              ),
            ),
    );
  }
}

class NameDialog extends StatefulWidget {
  const NameDialog({Key? key}) : super(key: key);

  @override
  _NameDialogState createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  final _nameController = TextEditingController();
  final _referalController = TextEditingController();
  bool referal = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(width * 0.032),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: width * 0.05),
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: width * 0.07,
              fontWeight: FontWeight.w500,
              color: Colors.red.shade900,
            ),
          ),
          SizedBox(height: width * 0.07),
          Row(
            children: [
              Text(
                ' Name',
                style: TextStyle(
                  fontSize: width * 0.045,
                  color: Colors.red.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.025),
          textFeild('Enter Your Name', _nameController),
          SizedBox(height: width * 0.08),
          referal
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          ' Referral Code (Optional)',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.025),
                    textFeild('(Optional) Enter code', _referalController),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      referal = true;
                    });
                  },
                  child: Text(
                    'Have a referral code?',
                    style: TextStyle(
                      fontSize: width * 0.045,
                      color: Colors.red.shade900,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
          SizedBox(height: width * 0.1),
          Container(
            width: double.infinity,
            height: width * 0.14,
            decoration: BoxDecoration(
              color: Palate.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RawMaterialButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  context
                      .read<AuthModel>()
                      .submitName(context, _nameController.text);
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: width * 0.052,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget textFeild(String hint, TextEditingController controller) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Palate.primary.withOpacity(0.15),
      ),
      child: TextFormField(
        cursorColor: Colors.red.withOpacity(0.8),
        keyboardType: TextInputType.name,
        style: const TextStyle(
          fontSize: 18,
        ),
        controller: controller,
        onChanged: (_) {
          // context
          //     .read<AuthModel>()
          //     .getPhoneNum(_phoneController.text);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: width * 0.05,
            horizontal: width * 0.05,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: width * 0.044,
            color: Colors.red.shade300,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
