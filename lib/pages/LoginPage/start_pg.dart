import 'package:flutter/material.dart';
import 'package:zommiy/Utils/utils.dart';

import 'login_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Palate.primary,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.25,
                child: Image.asset('assets/images/trans.jpeg'),
              ),
              Padding(
              padding: EdgeInsets.all(width * 0.032),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.7,
                    child: RichText(
                      text: TextSpan(
                          text: 'Find the ',
                          style: TextStyle(
                            fontSize: width * 0.067,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'MontsM',
                          ),
                          children: [
                            TextSpan(
                              text: 'Best Food ',
                              style: TextStyle(
                                fontSize: width * 0.067,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'MontsB',
                              ),
                            ),
                            TextSpan(
                              text: 'Deals ',
                              style: TextStyle(
                                fontSize: width * 0.067,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'MontsB',
                              ),
                            ),
                            const TextSpan(text: 'Around you'),
                          ]),
                    ),
                  ),
                  SizedBox(height: width * 0.1),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: width * 0.006),
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: width * 0.048,
                          fontWeight: FontWeight.w400,
                          color: Palate.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.1),
                ],
              ),
            ),
            ],
          ),
          Positioned(
            top: width * 0.36,
            child: Image.asset('assets/images/friends.png'),
          ),
         
        ],
      ),
    );
  }
}
