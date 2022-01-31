import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/restaurant_model.dart';

import 'final_screen.dart';

var user = FirebaseAuth.instance.currentUser;

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String? _userName;
  String? _userPhone;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        _userName = value['name'];
        _userPhone = value['phonenumber'];
      });
    });
  }

  String currentTime = DateTime.now().hour < 13
      ? DateTime.now().minute < 10
          ? '${DateTime.now().hour}:0${DateTime.now().minute} AM'
          : '${DateTime.now().hour}:${DateTime.now().minute} AM'
      : DateTime.now().minute < 10
          ? '${DateTime.now().hour - 12}:0${DateTime.now().minute} PM'
          : '${DateTime.now().hour - 12}:${DateTime.now().minute} PM';

  Future placeOrder(Map items, int quantity, List itemList, double totalPrice,
      String restId) async {
    double taxes = totalPrice * 5 / 100;
    try {
      DocumentReference _docRef =
          await Ref.restRef.doc(restId).collection('orders').add({
        'useruid': user!.uid,
        'name': _userName,
        'phoneNumber': _userPhone,
        'totalPrice': totalPrice,
        'totalPriceTaxes': totalPrice + taxes,
        'stage': 0,
        'time': currentTime,
        'date':
            '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}'
      });

      for (var item in itemList) {
        await Ref.ordersRef.doc(_docRef.id).collection('dishes').add({
          'veg': items[item]['veg'],
          'dish-name': items[item]['name'],
          'price': items[item]['price'],
          'quantity': quantity,
          'unit': items[item]['unit'],
          'unitQuantity': items[item]['unitQuantity'],
          'type': items[item]['type'],
          'spicy': items[item]['spicy'],
        });
      }
      context.read<CartItems>().getOrderId(_docRef.id);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FinalScreen()));

      return 'done!';
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appbar(width),
      body: Stack(
        children: [
          Container(
            width: width,
            color: Colors.grey.shade200,
            child: ListView(
              children: [
                SizedBox(height: width * 0.005),
                restaurantDetail(width),
                SizedBox(height: width * 0.025),
                dishes(width),
                SizedBox(height: width * 0.025),
                coupons(width),
                SizedBox(height: width * 0.025),
                billDetails(),
              ],
            ),
          ),
          orderPlaceButton(),
        ],
      ),
    );
  }

  Widget billDetails() {
    double width = MediaQuery.of(context).size.width;
    double totalPrice = context.watch<CartItems>().totalPrice.toDouble();
    double taxes = totalPrice * 5 / 100;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: width * 0.04,
        horizontal: width * 0.027,
      ),
      width: width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Details',
            style: TextStyle(
              fontSize: width * 0.048,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: width * 0.025),
          eachBill('Item total', '₹$totalPrice'),
          eachBill('Taxes and Charges', '₹$taxes'),
          Divider(color: Colors.grey.shade300, thickness: 2),
          totalBill('Total Price', '₹${totalPrice + taxes}'),
          SizedBox(height: width * 0.3),
        ],
      ),
    );
  }

  Widget orderPlaceButton() {
    double width = MediaQuery.of(context).size.width;
    double totalPrice = context.watch<CartItems>().totalPrice.toDouble();
    double taxes = totalPrice * 5 / 100;
    Map items = context.watch<CartItems>().items;
    int quantity = context.watch<RestaurantModel>().quantity;
    List itemList = context.watch<CartItems>().itemList;
    String? id = context.watch<RestaurantModel>().restaurantId;
    return Positioned(
      bottom: width * 0.02,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: width * 0.02),
        color: Colors.white,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.485,
              height: width * 0.15,
              alignment: Alignment.center,
              child: Text(
                '₹${totalPrice + taxes}',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                var status =
                    placeOrder(items, quantity, itemList, totalPrice, id!);

                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => FinalScreen()));
              },
              child: Container(
                width: width * 0.485,
                height: width * 0.15,
                decoration: BoxDecoration(
                    color: Palate.secondary,
                    borderRadius: BorderRadius.circular(15)),
                alignment: Alignment.center,
                child: Text(
                  'Place order',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalBill(String text, price) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: width * 0.046,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget eachBill(String text, price) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: width * 0.041,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: width * 0.042,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget coupons(double width) => Container(
        padding: EdgeInsets.symmetric(
          vertical: width * 0.04,
          horizontal: width * 0.027,
        ),
        width: width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offers',
              style: TextStyle(
                fontSize: width * 0.048,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: width * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/GiftN.svg'),
                    SizedBox(width: width * 0.025),
                    Text(
                      'Selecte a promo code',
                      style: TextStyle(
                        fontSize: width * 0.037,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  'View offers',
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
      );

  Widget dishes(double width) {
    Map items = context.watch<CartItems>().items;
    List itemList = context.watch<CartItems>().itemList;
    return Column(
      children: [
        for (var item in itemList)
          Container(
            padding: EdgeInsets.symmetric(
              vertical: width * 0.04,
              horizontal: width * 0.027,
            ),
            width: width,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      height: width * 0.058,
                      width: width * 0.058,
                      image: items[item]['veg']
                          ? const AssetImage('assets/images/veg-img.png')
                          : const AssetImage('assets/images/non-veg-icon.png'),
                    ),
                    SizedBox(width: width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[item]['name'],
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: width * 0.008),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${items[item]['price']} ',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.47,
                              child: Text(
                                '(${items[item]['unitQuantity']} ${items[item]['unit']}, ${items[item]['type']}, ${items[item]['spicy']})',
                                style: TextStyle(
                                  fontSize: width * 0.038,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          'CUSTOMIZED',
                          style: TextStyle(
                            fontSize: width * 0.032,
                            color: Palate.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.02),
                      width: width * 0.27,
                      height: width * 0.095,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: Border.all(
                          width: 1,
                          color: Palate.primary,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (items.containsKey(item) &&
                                  items[item]['quantity'] <= 1) {
                                context.read<CartItems>().removeItem(item);
                              } else {
                                context
                                    .read<CartItems>()
                                    .decreaseQuantity(item);
                              }
                            },
                            child: Icon(
                              Icons.remove,
                              size: width * 0.06,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            items[item]['quantity'].toString(),
                            style: TextStyle(
                              fontSize: width * 0.044,
                              fontWeight: FontWeight.w600,
                              color: Palate.primary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<CartItems>().increaseQuantity(item);
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: width * 0.06,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: width * 0.012),
                    Text(
                      '₹${items[item]['totalPrice']}',
                      style: TextStyle(
                        fontSize: width * 0.036,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget restaurantDetail(width) {
    String? name = context.watch<RestaurantModel>().name;
    String? dishType = context.watch<RestaurantModel>().dishType;
    String? location = context.watch<RestaurantModel>().location;
    return Container(
      padding: EdgeInsets.all(width * 0.027),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name!,
            style: TextStyle(
              fontSize: width * 0.072,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            dishType!,
            style: TextStyle(
              fontSize: width * 0.037,
              fontWeight: FontWeight.w400,
              height: width * 0.004,
            ),
          ),
          Text(
            location ?? 'update in backend',
            style: TextStyle(
                fontSize: width * 0.037,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w400,
                height: width * 0.0034),
          ),
        ],
      ),
    );
  }

  AppBar appbar(double width) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: width * 0.065,
        ),
      ),
    );
  }
}
