import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/restaurant_model.dart';

class FinalScreen extends StatefulWidget {
  const FinalScreen({Key? key}) : super(key: key);

  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.all(width * 0.027),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderDetails(),
            orderTime(),
            timeLine(),
          ],
        ),
      ),
    );
  }

  Widget timeLine() {
    double width = MediaQuery.of(context).size.width;
    String? orderId = context.read<CartItems>().orderId;
    String? id = context.watch<RestaurantModel>().restaurantId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.082),
            height: width * 1,
            width: 1,
            color: Palate.primary,
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: Ref.restRef
                  .doc(id)
                  .collection('orders')
                  .doc(orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.hasData) {
                  Map<String, dynamic> e =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      timelineItem(
                          'Order received',
                          'We have received your order',
                          'list.svg',
                          0,
                          e['stage']),
                      timelineItem(
                          'Order Confirmed',
                          'Restaurant has confirmed your order',
                          'tick.svg',
                          1,
                          e['stage']),
                      timelineItem(
                          'Preparing Order',
                          'The restaurant is preparing your food',
                          'serve.svg',
                          2,
                          e['stage']),
                      timelineItem(
                          'Order Delivered ',
                          'Delivered! Enjoy your meal.',
                          'chicken.svg',
                          3,
                          e['stage']),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }

  Widget timelineItem(String text, String subtext, img, int index, int stage) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          stage = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
        margin: EdgeInsets.symmetric(vertical: width * 0.01),
        padding: stage == index
            ? EdgeInsets.all(width * 0.04)
            : EdgeInsets.symmetric(vertical: width * 0.06),
        decoration: stage == index
            ? BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400.withOpacity(0.8),
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              )
            : BoxDecoration(),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.02),
              width: width * 0.17,
              height: width * 0.17,
              decoration: stage != index
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palate.primary,
                    )
                  : const BoxDecoration(),
              child: SvgPicture.asset(
                'assets/icons/$img',
                color: stage != index ? Colors.white : Palate.primary,
              ),
            ),
            SizedBox(width: width * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: width * 0.046,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  subtext,
                  style: TextStyle(
                    fontSize: width * 0.036,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget orderTime() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.015),
        Text(
          'The food will be served to you in about',
          style: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: height * 0.007),
        Text(
          '50 min',
          style: TextStyle(
            fontSize: width * 0.08,
            fontWeight: FontWeight.w500,
            color: Palate.primary,
          ),
        ),
        Divider(thickness: 1, color: Colors.grey.shade400, height: 0),
      ],
    );
  }

  Widget orderDetails() {
    double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width * 0.3,
          height: width * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade400,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #3182',
              style: TextStyle(
                fontSize: width * 0.055,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: width * 0.02),
            Text(
              'KFC India',
              style: TextStyle(
                fontSize: width * 0.042,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(width * 0.022),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.shade300,
          ),
          child: Text(
            'View Orders',
            style: TextStyle(
              fontSize: width * 0.036,
              fontWeight: FontWeight.w700,
              color: Palate.primary,
            ),
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Palate.primary,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios),
      ),
      title: Text('Order Status'),
      centerTitle: true,
    );
  }
}
