import 'package:flutter/material.dart';

class Carosuel extends StatefulWidget {
  const Carosuel({Key? key}) : super(key: key);

  @override
  _CarosuelState createState() => _CarosuelState();
}

class _CarosuelState extends State<Carosuel> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          height: width * 0.47,
          width: width,
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage('assets/images/img8.jpeg'), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Positioned(
            bottom: width * 0.04,
            child: SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  dot(),
                  dot(),
                  dot(),
                  dot(),
                ],
              ),
            ))
      ],
    );
  }

  Widget dot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
