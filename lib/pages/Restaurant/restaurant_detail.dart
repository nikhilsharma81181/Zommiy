import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/restaurant_model.dart';

import 'bottom_sheet.dart';
import 'cart.dart';

CollectionReference _restRef =
    FirebaseFirestore.instance.collection('restaurants');

class RestaurantDetails extends StatefulWidget {
  const RestaurantDetails({Key? key}) : super(key: key);

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  final GlobalKey<ScaffoldState> _drawerkey = GlobalKey();
  bool value = true;
  bool value1 = true;
  List price = [499, 599, 125, 249, 329, 110];
  bool added = false;
  Timer timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String? restaurantId = context.watch<RestaurantModel>().restaurantId;
    return Scaffold(
      key: _drawerkey,
      appBar: appBar(),
      drawer: const Drawer(),
      body: restaurantId == null
          ? const CircularProgressIndicator()
          : StreamBuilder(
              stream: _restRef.doc(restaurantId).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    width: width,
                    height: height,
                    alignment: Alignment.center,
                    child: const Text('Something went wrong'),
                  );
                }
                if (snapshot.hasData) {
                  Map<String, dynamic> e =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Stack(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.025),
                        child: ListView(
                          children: [
                            subHeader(e),
                            SizedBox(height: height * 0.01),
                            search(),
                            SizedBox(height: height * 0.012),
                            offerBanner(),
                            SizedBox(height: height * 0.012),
                            vegSwitch(),
                            Divider(
                                color: Colors.grey.shade300, thickness: 1.5),
                            SizedBox(height: height * 0.012),
                            breakfast(),
                            SizedBox(height: height * 0.012),
                            Column(
                              children: [
                                for (var item in e['category'])
                                  buildDishes(item),
                              ],
                            ),
                            SizedBox(height: height * 0.25),
                          ],
                        ),
                      ),
                      buildFloatingMenu(e)
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
    );
  }

  Widget buildFloatingMenu(Map<String, dynamic> e) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Map items = context.watch<CartItems>().items;
    return Positioned(
      bottom: width * 0.027,
      child: Container(
        width: width,
        padding: EdgeInsets.all(width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // browseMenuList(e),
            // SizedBox(height: height * 0.017),
            // browseMenu(),
            SizedBox(height: height * 0.017),
            if (items.isNotEmpty) floatingCartBar(e),
          ],
        ),
      ),
    );
  }

  Widget floatingCartBar(Map<String, dynamic> e) {
    double width = MediaQuery.of(context).size.width;
    int quantity = context.watch<CartItems>().quantity;
    int totalPrice = context.watch<CartItems>().totalPrice;
    return GestureDetector(
      onTap: () {
        context
            .read<RestaurantModel>()
            .getRestaurantDetails(e['name'], e['dish-type'], 'not in backend');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Cart()));
        // print(items);
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(width * 0.027),
        decoration: BoxDecoration(
          color: Palate.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$quantity ITEMS',
                  style: TextStyle(
                    fontSize: width * 0.032,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: width * 0.018),
                RichText(
                  text: TextSpan(
                    text: '₹$totalPrice ',
                    style: TextStyle(
                      fontSize: width * 0.047,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: '  plus taxes',
                        style: TextStyle(
                          fontSize: width * 0.032,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'View Cart',
                  style: TextStyle(
                    fontSize: width * 0.048,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: width * 0.01),
                Icon(
                  Icons.shopping_bag_outlined,
                  size: width * 0.072,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget breakfast() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Breakfast & snacks (10)',
              style: TextStyle(
                fontSize: width * 0.048,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.expand_less, size: width * 0.08),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: width * 0.05),
            child: Row(
              children: [
                SizedBox(width: width * 0.03),
                breakfastItems(price[0].toString()),
                SizedBox(width: width * 0.05),
                breakfastItems(price[1].toString()),
                SizedBox(width: width * 0.05),
                breakfastItems(price[2].toString()),
                SizedBox(width: width * 0.03),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget breakfastItems(price) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(width * 0.027),
          width: width * 0.41,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 2,
                color: Colors.black.withOpacity(0.15),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Paneer Pizza',
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: width * 0.012),
              CircleAvatar(
                radius: width * 0.15,
                backgroundColor: Palate.primary,
              ),
              SizedBox(height: width * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '20 min',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_outline,
                        color: Palate.primary,
                        size: width * 0.05,
                      ),
                      Text(
                        '55',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: width * 0.012),
              Row(
                children: [
                  Text(
                    '₹$price',
                    style: TextStyle(
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.032),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  added = true;
                });
              },
              child: Container(
                padding: EdgeInsets.all(width * 0.025),
                decoration: const BoxDecoration(
                  color: Palate.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: width * 0.07,
                ),
              ),
            )),
      ],
    );
  }

  Widget buildDishes(String item) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String? restaurantId = context.watch<RestaurantModel>().restaurantId;
    return StreamBuilder(
      stream: _restRef
          .doc(restaurantId)
          .collection('dishes')
          .where('category', isEqualTo: item)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: const Text('Something went wrong'),
          );
        }
        if (snapshot.hasData) {
          return ExpansionTile(
              title: Text(
                item,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.0525,
                  fontWeight: FontWeight.w600,
                ),
              ),
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              initiallyExpanded: true,
              children: [
                ...snapshot.data!.docs.map(
                  (e) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding:
                                EdgeInsets.symmetric(vertical: width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width * 0.052,
                                  height: width * 0.052,
                                  child: Image(
                                    image: e['veg']
                                        ? const AssetImage(
                                            'assets/images/veg-img.png')
                                        : const AssetImage(
                                            'assets/images/non-veg-icon.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: width * 0.012),
                                Text(
                                  e['name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: width * 0.047,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: width * 0.005),
                                Text(
                                  e['category'],
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: width * 0.038,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: width * 0.016),
                                Text(
                                  '₹${e['price'][0]}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: width * 0.02),
                                Container(
                                  padding: EdgeInsets.all(width * 0.004),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.amber.shade100.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      width: 0.05,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  child: RatingBarIndicator(
                                    rating: 4.5,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: width * 0.038,
                                    unratedColor: Colors.amber.withAlpha(50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          e['active']
                              ? buildAddButton(e['name'], 23, 1, e['veg'], e)
                              : Column(
                                  children: [
                                    Text(
                                      'Not available ',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: width * 0.042,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'It will be back asap',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: width * 0.038,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      )
                    ],
                  ),
                ),
              ].toList());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildAddButton(
      String name, int price, qnty, bool veg, QueryDocumentSnapshot e) {
    double width = MediaQuery.of(context).size.width;
    Map items = context.watch<CartItems>().items;
    return !items.containsKey(name)
        ? GestureDetector(
            onTap: () {
              context.read<RestaurantModel>().resetSelectedData();
              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )),
                context: context,
                builder: (_) {
                  return BottomSlider(e: e);
                },
              );
            },
            child: Container(
              padding: EdgeInsets.all(width * 0.025),
              decoration: const BoxDecoration(
                color: Palate.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: width * 0.07,
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(width * 0.02),
            width: width * 0.29,
            height: width * 0.1,
            decoration: BoxDecoration(
              color: Palate.primary.withOpacity(0.04),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              border: Border.all(
                width: 0.7,
                color: Palate.primary,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (items.containsKey(name) &&
                        items[name]['quantity'] <= 1) {
                      context.read<CartItems>().removeItem(name);
                    } else {
                      context.read<CartItems>().decreaseQuantity(name);
                    }
                  },
                  child: Icon(
                    Icons.remove,
                    size: width * 0.057,
                    color: Colors.black,
                  ),
                ),
                Text(
                  items[name]['quantity'] != null
                      ? items[name]['quantity'].toString()
                      : '1',
                  style: TextStyle(
                    fontSize: width * 0.052,
                    fontWeight: FontWeight.w600,
                    color: Palate.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<CartItems>().increaseQuantity(name);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: width * 0.057,
                  ),
                ),
              ],
            ),
          );
  }

  Widget vegSwitch() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: width * 0.001, bottom: width * 0.006),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Switch.adaptive(
                value: value,
                activeColor: Palate.secondary,
                onChanged: (_) {
                  setState(() {
                    value == true ? value = false : value = true;
                  });
                },
              ),
              Text(
                'Veg',
                style: TextStyle(
                  fontSize: width * 0.041,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: width * 0.032,
              ),
              Switch.adaptive(
                value: value1,
                activeColor: Colors.red,
                onChanged: (_) {
                  setState(() {
                    value1 == true ? value1 = false : value1 = true;
                  });
                },
              ),
              Text(
                'Non-Veg',
                style: TextStyle(
                  fontSize: width * 0.041,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            'Offers',
            style: TextStyle(
              fontSize: width * 0.041,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget offerBanner() {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: width * 0.012),
            width: width * 0.45,
            height: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.deepPurple,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: width * 0.012),
            width: width * 0.45,
            height: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.deepPurple,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: width * 0.012),
            width: width * 0.45,
            height: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget foodItems(double width) {
    return Container(
      width: width,
      height: width * 0.25,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget browseMenu() {
    double width = MediaQuery.of(context).size.width;
    Map items = context.watch<CartItems>().items;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print(items);
          },
          child: Container(
            width: width * 0.48,
            height: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.list,
                  color: Colors.white,
                  size: width * 0.062,
                ),
                SizedBox(width: width * 0.015),
                Text(
                  'Browse menu',
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget search() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.137,
      margin: EdgeInsets.symmetric(
        vertical: width * 0.012,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.9),
        border: Border.all(
          width: 2,
          color: Colors.grey.shade400.withOpacity(0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: width * 0.035),
          Icon(
            Icons.search,
            color: Colors.red,
            size: width * 0.07,
          ),
          SizedBox(width: width * 0.03),
          Text(
            'Search within the menu...',
            style: TextStyle(
              fontSize: width * 0.047,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget subHeader(Map<String, dynamic> e) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.01),
        Text(
          e['name'],
          style: TextStyle(
            fontSize: width * 0.07,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          'Coffee',
          style: TextStyle(
            fontSize: width * 0.042,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            height: width * 0.002,
          ),
        ),
        Text(
          'xyz street near abc, theatre',
          style: TextStyle(
            fontSize: width * 0.04,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
            height: width * 0.003,
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: const SizedBox(),
      actions: [
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SizedBox(
                  width: width * 0.1,
                  child: Icon(
                    Icons.arrow_back,
                    size: width * 0.07,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _drawerkey.currentState!.openDrawer();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.06,
                        height: 2.6,
                        color: Colors.black,
                      ),
                      SizedBox(height: width * 0.0085),
                      Container(
                        width: width * 0.045,
                        height: 2.6,
                        color: Colors.black,
                      ),
                      SizedBox(height: width * 0.0085),
                      Container(
                        width: width * 0.037,
                        height: 2.6,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
