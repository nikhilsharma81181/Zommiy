import 'package:flutter/material.dart';
import 'package:zommiy/Utils/utils.dart';

class Referalls extends StatefulWidget {
  const Referalls({Key? key}) : super(key: key);

  @override
  _ReferallsState createState() => _ReferallsState();
}

class _ReferallsState extends State<Referalls> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: width * 0.05,
      ),
      child: Column(
        children: [
          header(),
          SizedBox(height: width * 0.037),
          buildBody('Lord Nikhil'),
          buildBody('Abhinav'),
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
          Text(
            name,
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: width * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Referal status: ',
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Text(
                '100 Order',
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.047),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              referalStatus('Signed Up'),
              referalStatus('Profile Completed'),
              referalStatus('Ordered'),
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
              'Remind $name',
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

  Widget referalStatus(String text) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(
          Icons.check_circle_outlined,
          size: width * 0.05,
          color: Palate.secondary,
        ),
        Text(
          ' $text',
          style: TextStyle(
            fontSize: width * 0.037,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
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
                  'Refer now to earn',
                  style: TextStyle(
                    fontSize: width * 0.047,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Increase referal earning on each successful invite',
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
