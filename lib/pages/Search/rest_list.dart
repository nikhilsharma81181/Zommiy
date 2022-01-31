import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/restaurant_model.dart';
import 'package:zommiy/pages/Restaurant/restaurant_detail.dart';

class RestList extends StatefulWidget {
  const RestList({Key? key}) : super(key: key);

  @override
  _RestListState createState() => _RestListState();
}

class _RestListState extends State<RestList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Ref.restRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 57),
            child: ListView(
              children: snapshot.data!.docs.map((e) => restaurant(e)).toList(),
            ),
          );
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      },
    );
  }

  Widget restaurant(QueryDocumentSnapshot e) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        context.read<RestaurantModel>().getRestaurantId(e.id, '1');
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RestaurantDetails()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.01, horizontal: width * 0.032),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: width * 0.32,
                height: width * 0.22,
                child: Image.asset(
                  'assets/images/a5.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: width * 0.027),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width * 0.02),
                Text(
                  e['name'],
                  style: TextStyle(
                    fontSize: width * 0.052,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: width * 0.017),
                Text(
                  e['dish-type'],
                  style: TextStyle(
                    fontSize: width * 0.0355,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  e['email'],
                  style: TextStyle(
                    fontSize: width * 0.034,
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
}
