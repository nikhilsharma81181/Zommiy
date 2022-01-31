import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';
import 'package:zommiy/Utils/utils.dart';

class Rewards extends StatefulWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.05),
      child: ListView(
        children: [
          header(),
          Wrap(
            spacing: width * 0.07,
            children: [
              scratchCard(),
              scratchCard(),
              scratchCard(),
              scratchCard(),
              scratchCard(),
              scratchCard(),
              scratchCard(),
            ],
          )
        ],
      ),
    );
  }

  Widget scratchCard() {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: const ScratchCard(),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: width * 0.037),
        padding: EdgeInsets.all(width * 0.092),
        width: width * 0.41,
        height: width * 0.41,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Palate.primary,
        ),
        child: Container(
          padding: EdgeInsets.all(width * 0.042),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Image(
            image: AssetImage('assets/images/reward.png'),
          ),
        ),
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
                  'Scratch card worth upto ₹1000',
                  style: TextStyle(
                    fontSize: width * 0.047,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Scratch cards to get rewards',
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

class ScratchCard extends StatefulWidget {
  const ScratchCard({Key? key}) : super(key: key);

  @override
  _ScratchCardState createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> {
  bool won = false;
  double scratchValue = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        curve: Curves.bounceOut,
        duration: const Duration(milliseconds: 500),
        height: won ? width * 0.8 : width * 0.65,
        width: won ? width * 0.8 : width * 0.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: !won
            ? Scratcher(
                brushSize: 30,
                threshold: 50,
                color: Palate.primary,
                rebuildOnResize: false,
                onChange: (value) {
                  scratchValue = value;
                  // ignore: avoid_print
                  print("Scratch progress: $value%");
                },
                onScratchEnd: () {
                  if (scratchValue > 25.00) {
                    setState(() {
                      won = true;
                    });
                  }
                },
                // ignore: avoid_print
                onThreshold: () => print("Threshold reached, you won!"),
                child: SizedBox(
                  width: width * 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/given-reward.png',
                        width: width * 0.3,
                        height: width * 0.3,
                      ),
                      SizedBox(height: width * 0.02),
                      Text(
                        'You won',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: width * 0.05),
                      Text(
                        '₹ 1000',
                        style: TextStyle(
                          fontSize: width * 0.075,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/given-reward.png',
                    width: width * 0.3,
                    height: width * 0.3,
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    'You won',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: width * 0.05),
                  Text(
                    '₹ 1000',
                    style: TextStyle(
                      fontSize: width * 0.075,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
