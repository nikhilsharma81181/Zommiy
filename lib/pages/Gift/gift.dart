import 'package:flutter/material.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/pages/Gift/referrals.dart';
import 'package:zommiy/pages/Gift/rewards.dart';
import 'package:zommiy/pages/Gift/saved.dart';

class Gift extends StatefulWidget {
  const Gift({Key? key}) : super(key: key);

  @override
  _GiftState createState() => _GiftState();
}

class _GiftState extends State<Gift> with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(initialIndex: 0, length: 3, vsync: this);

    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: SizedBox(
          width: width,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification? overscroll) {
              overscroll!.disallowIndicator();
              return true;
            },
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, isScrolled) => [
                appbar(),
              ],
              body: TabBarView(
                controller: _controller,
                children: const [
                  Rewards(),
                  Referalls(),
                  SavedReward(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar appbar() {
    double width = MediaQuery.of(context).size.width;
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      actions: [
        SizedBox(
          width: width,
          child: SingleChildScrollView(
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                buildHeader(),
              ],
            ),
          ),
        ),
      ],
      toolbarHeight: width * 0.4,
      bottom: TabBar(
        controller: _controller,
        isScrollable: true,
        labelStyle: TextStyle(
          fontSize: width * 0.045,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: Colors.black,
        labelColor: Palate.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.symmetric(horizontal: width * 0.08),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Palate.primary, width: 2),
        ),
        tabs: const [
          Tab(
            text: 'Rewards',
          ),
          Tab(
            text: 'Referrals',
          ),
          Tab(
            text: 'Saved',
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035),
          child: _controller != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _controller!.index == 0
                          ? 'Total Reward Earned'
                          : _controller!.index == 1
                              ? 'Total Successful Referal'
                              : 'Total Rewards Earned',
                      style: TextStyle(
                        fontSize: width * 0.042,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _controller!.index == 0
                          ? '₹ 5000'
                          : _controller!.index == 1
                              ? '26'
                              : '₹ 850',
                      style: TextStyle(
                        fontSize: width * 0.075,
                        fontWeight: FontWeight.w700,
                        color: _controller!.index != 1
                            ? Palate.secondary
                            : Palate.primary,
                      ),
                    ),
                  ],
                )
              : Column(),
        ),
        SizedBox(
          width: width * 0.38,
          height: width * 0.38,
          child: Image.asset('assets/images/tab${_controller!.index + 1}.png'),
        ),
      ],
    );
  }
}
