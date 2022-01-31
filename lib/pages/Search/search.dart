import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/restaurant_model.dart';
import 'package:zommiy/pages/Restaurant/restaurant_detail.dart';
import 'package:zommiy/pages/Search/rest_list.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}


class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(initialIndex: 0, length: 4, vsync: this);

    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String? searchTxt = context.watch<RestaurantModel>().searchCtrl;
    return DefaultTabController(
      length: 4,
      child: SizedBox(
        width: width,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification? overscroll) {
            overscroll!.disallowGlow();
            return true;
          },
          child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, isScrolled) => [
                    SliverPersistentHeader(
                      delegate: MyDelegate(
                        TabBar(
                          controller: _controller,
                          isScrollable: true,
                          labelStyle: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelColor: Colors.black,
                          labelColor: Palate.primary,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: width * 0.034),
                          indicator: const UnderlineTabIndicator(
                            borderSide:
                                BorderSide(color: Palate.primary, width: 2),
                          ),
                          tabs: const [
                            Tab(
                              text: 'Recent',
                            ),
                            Tab(
                              text: 'Trending',
                            ),
                            Tab(
                              text: 'Suggested',
                            ),
                            Tab(
                              text: 'Featured',
                            ),
                          ],
                        ),
                        width,
                        searchTxt,
                      ),
                      floating: true,
                      pinned: true,
                    )
                  ],
              body: searchTxt == ''
                  ? TabBarView(
                      controller: _controller,
                      children: const [
                        RestList(),
                        RestList(),
                        RestList(),
                        RestList(),
                      ],
                    )
                  : searched()),
        ),
      ),
    );
  }

  Widget searched() {
    String searchTxt = context.watch<RestaurantModel>().searchCtrl;
    return StreamBuilder(
      stream: Ref.restRef
          .where('name', isGreaterThanOrEqualTo: searchTxt.toUpperCase())
          .snapshots(),
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

  Widget buildHeader() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width,
          height: width * 0.5,
          color: Colors.red,
        ),
      ],
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final double width;
  final String? searchTxt;
  MyDelegate(this.tabBar, this.width, this.searchTxt);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: width,
                  height: width * 0.5,
                  child: Image.asset(
                    'assets/images/searchbg.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Palate.primary.withOpacity(0.4),
                  ),
                ),
                Positioned(
                  bottom: width * 0.1,
                  left: width * 0.07,
                  width: width * 0.8,
                  child: Text(
                    'Search for the Best Food Deals around you. ',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SafeArea(child: SearchBar()),
            if (searchTxt == '') tabBar,
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => searchTxt == ''
      ? tabBar.preferredSize.height + width * 0.78
      : tabBar.preferredSize.height + width * 0.20;

  @override
  double get minExtent => searchTxt == ''
      ? tabBar.preferredSize.height + width * 0.25
      : tabBar.preferredSize.height + width * 0.10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(width * 0.027),
      height: width * 0.14,
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: searchCtrl,
        style: TextStyle(fontSize: width * 0.048),
        cursorColor: Palate.primary,
        onChanged: (_) {
          context.read<RestaurantModel>().getSearchData(searchCtrl.text);
        },
        decoration: InputDecoration(
          hintText: 'Search for restaurants and food',
          hintStyle: TextStyle(
            fontSize: width * 0.042,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
