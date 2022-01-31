import 'package:flutter/material.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/pages/Restaurant/restaurant_detail.dart';

import 'carosuel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification? overscroll) {
            overscroll!.disallowIndicator();
            return true;
          },
          child: ListView(
            children: [
              header(),
              SizedBox(height: height * 0.012),
              const Carosuel(),
              SizedBox(height: height * 0.02),
              mostPopular(),
              SizedBox(height: height * 0.012),
              newRestaurant(),
              SizedBox(height: height * 0.012),
              bestDineIn(),
              SizedBox(height: height * 0.15),
            ],
          ),
        ),
      ),
    );
  }

  Widget mostPopular() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' Most popular',
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  'All',
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: width * 0.04,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: height * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              mostPopularCard('img5.jpeg', 'Imperial Hotel'),
              SizedBox(width: width * 0.02),
              mostPopularCard('img7.jpeg', 'Martian Hotel'),
              SizedBox(width: width * 0.02),
              mostPopularCard('img6.jpeg', 'Imperial Hotel'),
            ],
          ),
        ),
      ],
    );
  }

  Widget newRestaurant() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' New restaurants near you',
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  'All',
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: width * 0.04,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: height * 0.002),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              newRestCard('img7.jpeg'),
              SizedBox(width: width * 0.02),
              newRestCard('img2.jpeg'),
              SizedBox(width: width * 0.02),
              newRestCard('img6.jpeg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget bestDineIn() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' Best for Dinner',
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  'All',
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: width * 0.04,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: height * 0.002),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              newRestCard('img4.jpeg'),
              SizedBox(width: width * 0.02),
              newRestCard('img3.jpeg'),
              SizedBox(width: width * 0.02),
              newRestCard('img1.jpeg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget mostPopularCard(String image, name) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RestaurantDetails()));
      },
      child: Stack(
        children: [
          Container(
            height: width * 0.47,
            width: width * 0.432,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage('assets/images/$image'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: width * 0.47,
            width: width * 0.432,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF7E7E7E).withOpacity(0),
                  const Color(0xFF494747).withOpacity(0.69),
                  const Color(0xFF313131).withOpacity(1),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: width * 0.025,
            left: width * 0.022,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: width * 0.045,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: width * 0.4,
                  child: Text(
                    'North Indian, Mughlai, Chineses',
                    style: TextStyle(
                        fontSize: width * 0.038,
                        color: Colors.grey.shade200,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PoppinsN'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget newRestCard(String image) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RestaurantDetails()));
      },
      child: Container(
        height: width * 0.332,
        width: width * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage('assets/images/$image'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget header() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pin_drop_outlined,
                  size: width * 0.075,
                ),
                SizedBox(width: width * 0.02),
                Text(
                  'India',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Icon(
              Icons.notifications_outlined,
              size: width * 0.075,
            ),
          ],
        ),
        SizedBox(height: height * 0.032),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.01),
          width: width * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Find the ',
                    style: TextStyle(
                      fontSize: width * 0.062,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'MontsM',
                    ),
                    children: [
                      TextSpan(
                        text: 'Best Food Deals ',
                        style: TextStyle(
                          fontSize: width * 0.062,
                          color: Palate.primary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'MontsB',
                        ),
                      ),
                      const TextSpan(text: 'Around you'),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
