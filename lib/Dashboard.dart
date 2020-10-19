import 'dart:collection';

import 'package:Sample/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboarad_Details.dart';
import 'package:Sample/model/DashboardCategory.dart';
import 'package:flutter/material.dart';
import 'package:Sample/model/category.dart';
import 'package:Sample/LecturesList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dash extends StatefulWidget {
  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  List<Category> Categories = [];
  String Username;
  String User = " ";
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String UserId = '';
    int Len = 0;
    void getCurrentUser() async {
      final FirebaseUser user = await auth.currentUser();
      String uid;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (user == null) {
        print("Har Har Mahadev");
        uid = prefs.getString('Uid');
        print(uid);
      } else {
        print("Har Har Har Mahadev");
        uid = user.uid;
      }
      UserId = uid;
      Username = prefs.getString('UserName');
      print(UserId);
      print(Username);
      User = "Welcome  Back " + Username + ",";

      final fb =
          FirebaseDatabase.instance.reference().child("Students").child(UserId);

      fb.once().then((DataSnapshot snap) {
        print(snap);
        var data = snap.value;
        // var lecture = snap.value.keys;
        print(data);
        Categories.clear();
        if (data != true) {
          data.forEach((key, value) {
            Categories.add(new Category(value['Course'], value['image']));
          });
        }

        Len = Categories.length;
        setState(() {});
      });
    }

    getCurrentUser();
    print(UserId);

    // List<Category> result = LinkedHashSet<String>.from(Categories).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 50, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //  SvgPicture.asset("icons/menu.svg")
                Icon(Icons.menu),
              ],
            ),
            SizedBox(height: 30),
            Text(User, style: kHeadingextStyle),
            Text("Here is List of Courses You have enrolled...",
                style: kSubheadingextStyle),
            SizedBox(height: 30),
            Expanded(
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(0),
                crossAxisCount: 2,
                itemCount: Categories.length,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                itemBuilder: (context, index) {
                  return FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Dashboard_Details(Categories[index].name)),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(Categories[index].image),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Categories[index].name,
                              style: kTitleTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dash();
  }
}
