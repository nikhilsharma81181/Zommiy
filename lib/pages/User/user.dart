import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/auth_model.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.grey.shade200,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.032),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.05),
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                        color: Colors.grey.shade400,
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: width * 0.02),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: width * 0.15,
                      foregroundImage:
                          const AssetImage('assets/images/lord_nikhil.jpg'),
                    ),
                    SizedBox(height: width * 0.05),
                    Text(
                      'Lord Nikhil',
                      style: TextStyle(
                        fontSize: width * 0.061,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.03),
                    Text(
                      '9334587241',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.01),
                    Text(
                      'nikhilsharma81181@gmail.com',
                      style: TextStyle(
                        fontSize: width * 0.037,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.075),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        accountDetail('Saved', '₹1.5B', Palate.secondary),
                        accountDetail('Visited', '480', Colors.blue),
                        accountDetail('Points', '₹1M', Palate.secondary),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: width * 0.015),
              optonCard('Your Orders', () {}),
              optonCard('Favorite Orders', () {}),
              optonCard('Help', () {}),
              optonCard('Logout', () {
                context.read<AuthModel>().signOut();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget optonCard(String text, Function() fn) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      onPressed: fn,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: width * 0.055,
        ),
        margin: EdgeInsets.symmetric(
          vertical: height * 0.005,
        ),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: const Offset(0, 0),
              color: Colors.grey.shade400,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: width * 0.047,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget accountDetail(String header, value, Color color) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          header,
          style: TextStyle(
            fontSize: width * 0.041,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: width * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: width * 0.064,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
