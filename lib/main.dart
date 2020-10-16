import 'package:Sample/constants.dart';
import 'package:Sample/details_screen.dart';
import 'package:Sample/model/category.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:Sample/model/DashboardCategory.dart';
import 'package:Sample/Dashboard.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:Sample/chewie_list_item.dart';
import 'package:video_player/video_player.dart';
import 'package:Sample/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample App',
      theme: ThemeData(),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  List<Category> Categories = [];
  void initState() {
    // print("Har Har Mahadev");
    final fb = FirebaseDatabase.instance.reference().child("Subjects");
    // DatabaseReference ref = FirebaseDatabase.instance.reference();
    // ref.child('Computer Network').once().then((DataSnapshot snap) {
    //   var Lecture = snap.value.keys;
    //   var Link = snap.value;
    //   // var i = 1;
    //   for (var key in Lecture) {
    //     ListofLinks.add(new LectureList("01", Link[key]['Link'], key));
    //     // i = i + 1;
    //   }
    // });
    fb.once().then((DataSnapshot snap) {
      print(snap);
      var data = snap.value;
      // var lecture = snap.value.keys;
      // print(data);
      Categories.clear();

      data.forEach((key, value) {
        Categories.add(new Category(key, value['image']));
      });
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moj Kr ne"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new DrawerHeader(
              child: Icon(
                Icons.account_box,
                size: 90,
              ),
              decoration: BoxDecoration(color: Colors.white),
            ),
            ListTile(
              title: Text('Courses Enrolled'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
                //Navigator.pop(context);
              },
            ),
            //Text('Menu Item 1'),
            //Text('Menu Item 2')
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 50, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     //  SvgPicture.asset("icons/menu.svg")
            //     //  Icon(Icons.menu),
            //    // Image.asset("images/user.png"),
            //   ],
            // ),
            // SizedBox(height: 30),
            Text("Hey Avinash,", style: kHeadingextStyle),
            Text("Find a course you want to learn", style: kSubheadingextStyle),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: <Widget>[
                  //  SvgPicture.asset("icons/search.svg"),
                  // IconButton(
                  //     icon: Icon(Icons.search),
                  //     onPressed: () {
                  //       showSearch(context: context, delegate: SearchBar());
                  //     }),
                  // Icons.search;
                  FlatButton(
                    onPressed: () {
                      showSearch(context: context, delegate: SearchBar());
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search),
                        SizedBox(width: 16),
                        Text(
                          "Search for anything",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFA0A5BD),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Icon(Icons.search),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Courses", style: kTitleTextStyle),
                // Text(
                //   "See All",
                //   style: kSubtitleTextSyule.copyWith(color: kBlueColor),
                // ),
              ],
            ),
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
                            builder: (context) => DetailsScreen(
                                Categories[index].name,
                                Categories[index].image)),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          //height: index.isEven ? 200 : 240,
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
                        // Text(
                        //   '${categories[index].Instructor}',
                        //   style: TextStyle(
                        //     color: kTextColor.withOpacity(.5),
                        //   ),
                        // )
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class SearchBar extends SearchDelegate<String> {
  final Courses = [
    "Python",
    "Aws",
    "Computer Networking",
    "Java",
    "Operating System"
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query, style: TextStyle(fontSize: 20)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final my_list = query.isEmpty
        ? Courses
        : Courses.where((str) =>
                str.startsWith(query[0].toUpperCase() + query.substring(1)))
            .toList();
    return my_list.isEmpty
        ? Text("No Course Found....", style: TextStyle(fontSize: 20))
        : ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                showResults(context);
              },
              title: Text(my_list[index]),
            ),
            itemCount: my_list.length,
          );
  }
}

class VideoPlayer extends StatelessWidget {
  String Link;

  // final String link;
  VideoPlayer(String link) {
    Link = link;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              ChewieListItem(
                videoPlayerController: VideoPlayerController.network(
                  Link,
                ),
                looping: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
