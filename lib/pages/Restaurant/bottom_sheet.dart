import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/restaurant_model.dart';

class BottomSlider extends StatefulWidget {
  final QueryDocumentSnapshot e;
  const BottomSlider({Key? key, required this.e}) : super(key: key);

  @override
  _BottomSliderState createState() => _BottomSliderState();
}

class _BottomSliderState extends State<BottomSlider> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    QueryDocumentSnapshot e = widget.e;
    int quantity = context.watch<RestaurantModel>().quantity;
    int selectedPrice = context.watch<RestaurantModel>().selectedPrice;
    int selectedQuantityUnit =
        context.watch<RestaurantModel>().selectedQuantityUnit;
    int selectedType = context.watch<RestaurantModel>().selectedType;
    int selectedSpicy = context.watch<RestaurantModel>().selectedSpicy;
    Map items = context.watch<CartItems>().items;
    return Padding(
      padding: EdgeInsets.all(width * 0.045),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          e['name'],
                          style: TextStyle(
                            fontSize: width * 0.055,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Text(
                        e['category'],
                        style: TextStyle(
                          fontSize: width * 0.041,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(15),
                  //   child: Image(
                  //     height: width * 0.27,
                  //     width: width * 0.4,
                  //     image: NetworkImage(
                  //       e['photoUrl'],
                  //     ),
                  //     fit: BoxFit.cover,
                  //   ),
                  // )
                ],
              ),
              SizedBox(height: width * 0.04),
              if (e['unit'] != 'pieces')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e['unit'],
                      style: TextStyle(
                        fontSize: width * 0.041,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: width * 0.012),
                    Row(
                      children: [
                        for (var i = 0; i < e[e['unit']].length; i++)
                          bottomSheetOptions(e[e['unit']][i], e['unit'], i, e),
                      ],
                    ),
                    SizedBox(height: width * 0.04),
                  ],
                ),
              Text(
                'Type',
                style: TextStyle(
                  fontSize: width * 0.041,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: width * 0.012),
              Row(
                children: [
                  for (var i = 0; i < e['type'].length; i++)
                    bottomSheetOptions(e['type'][i], 'type', i, e),
                ],
              ),
              SizedBox(height: width * 0.04),
              Text(
                'Spicy',
                style: TextStyle(
                  fontSize: width * 0.041,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: width * 0.012),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < e['spicy'].length; i++)
                      bottomSheetOptions(e['spicy'][i], 'spicy', i, e),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildQuantity(),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.002, horizontal: width * 0.04),
                decoration: BoxDecoration(
                    color: Palate.secondary,
                    borderRadius: BorderRadius.circular(15)),
                child: RawMaterialButton(
                  onPressed: () {
                    context.read<CartItems>().addItem(
                          e['name'],
                          e['price'][selectedPrice],
                          quantity,
                          e['veg'],
                          e['unit'],
                          e['unit'] != 'pieces'
                              ? e[e['unit']][selectedQuantityUnit]
                              : 'null',
                          e['type'][selectedType],
                          e['spicy'][selectedSpicy],
                        );
                    if (items.containsKey(e['name'])) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Add ₹${e['price'][selectedPrice] * quantity}',
                    style: TextStyle(
                      fontSize: width * 0.042,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheetOptions(
      String text, String header, int index, QueryDocumentSnapshot e) {
    double width = MediaQuery.of(context).size.width;
    int selectedPrice = context.watch<RestaurantModel>().selectedPrice;
    int selectedType = context.watch<RestaurantModel>().selectedType;
    int selectedSpicy = context.watch<RestaurantModel>().selectedSpicy;
    return GestureDetector(
      onTap: () {
        if (header == e['unit']) {
          context.read<RestaurantModel>().updatePrice(index);
        } else if (header == 'type') {
          context.read<RestaurantModel>().updateType(index);
        } else if (header == 'spicy') {
          context.read<RestaurantModel>().updateSpicy(index);
        }
      },
      child: header == 'spicy'
          ? Container(
              margin: EdgeInsets.only(right: width * 0.02),
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.07, vertical: width * 0.017),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selectedSpicy == index
                      ? Palate.primary
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: width * 0.042,
                  color: selectedSpicy == index
                      ? Palate.primary
                      : Colors.grey.shade400,
                ),
              ),
            )
          : header == 'type'
              ? Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07,
                    vertical: width * 0.017,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedType == index
                          ? Palate.primary
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: width * 0.042,
                      color: selectedType == index
                          ? Palate.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.07, vertical: width * 0.017),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedPrice == index
                          ? Palate.primary
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: width * 0.042,
                      color: selectedPrice == index
                          ? Palate.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
    );
  }

  Widget buildQuantity() {
    double width = MediaQuery.of(context).size.width;
    int quantity = context.watch<RestaurantModel>().quantity;
    return Row(
      children: [
        Container(
            margin: EdgeInsets.only(right: width * 0.005),
            height: width * 0.092,
            width: width * 0.092,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Palate.primary)),
            alignment: Alignment.center,
            child: RawMaterialButton(
              onPressed: () {
                if (quantity > 1) {
                  context.read<RestaurantModel>().removeQuantity();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Icon(Icons.remove,
                  color: Palate.primary, size: width * 0.055),
            )),
        Container(
          margin: EdgeInsets.only(right: width * 0.005),
          height: width * 0.092,
          width: width * 0.092,
          alignment: Alignment.center,
          child: Text(
            quantity.toString(),
            style: TextStyle(fontSize: width * 0.05),
          ),
        ),
        Container(
            margin: EdgeInsets.only(right: width * 0.005),
            height: width * 0.092,
            width: width * 0.092,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Palate.primary)),
            alignment: Alignment.center,
            child: RawMaterialButton(
              onPressed: () {
                context.read<RestaurantModel>().addQuantity();
              },
              child:
                  Icon(Icons.add, color: Palate.primary, size: width * 0.055),
            )),
      ],
    );
  }
}
