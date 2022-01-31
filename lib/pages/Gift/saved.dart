import 'package:flutter/material.dart';
import 'package:zommiy/Utils/utils.dart';

class SavedReward extends StatefulWidget {
  const SavedReward({Key? key}) : super(key: key);

  @override
  _SavedRewardState createState() => _SavedRewardState();
}

class _SavedRewardState extends State<SavedReward> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.05),
      child: Column(
        children: [
          header(),
          SizedBox(height: width * 0.025),
          buildBody('Cafe Nova'),
          SizedBox(height: width * 0.025),
          buildBody('Biryani houser'),
        ],
      ),
    );
  }

  Widget buildBody(name) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.032),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Colors.grey.shade400,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: width * 0.015),
                  Text(
                    ' Order No: 3368',
                    style: TextStyle(
                      fontSize: width * 0.036,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    ' Date: 22.10.2021',
                    style: TextStyle(
                      fontSize: width * 0.036,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 1),
              const SizedBox(width: 1),
              Container(
                margin:
                    EdgeInsets.only(left: width * 0.02, right: width * 0.025),
                height: width * 0.17,
                width: 1,
                color: Colors.grey.shade400,
              ),
              Column(
                children: [
                  Text(
                    '₹235',
                    style: TextStyle(
                      fontSize: width * 0.075,
                      fontWeight: FontWeight.w700,
                      color: Palate.secondary,
                    ),
                  ),
                  Text(
                    'Saved',
                    style: TextStyle(
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 1),
            ],
          ),
          Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
          Container(
            width: width,
            padding: EdgeInsets.symmetric(vertical: width * 0.035),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palate.primary,
            ),
            alignment: Alignment.center,
            child: Text(
              'Order Detail',
              style: TextStyle(
                fontSize: width * 0.042,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.032),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Colors.grey.shade400,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/gem.png',
            height: width * 0.132,
            width: width * 0.16,
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.025),
            height: width * 0.17,
            width: 1,
            color: Colors.grey.shade400,
          ),
          SizedBox(
            width: width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total saved amount',
                  style: TextStyle(
                    fontSize: width * 0.047,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Amount saved in Dine-in through Foodla.',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
