import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nnn/Working/ScreenResolution.dart';
import 'package:nnn/Working/NewsArticle.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  //PART1
  @override
  State<Home> createState() => _HomeState();
}

class Category {
  late String name;
  Category(this.name);
}

class _HomeState extends State<Home> {
  //PART2
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  bool isLoading = true;
  List<Category> categories = [];
  List sliderItems = [Colors.yellow, Colors.black, Colors.lightBlueAccent];
  List<NewsArticle> newsArticles = [];

  Future<void> _fetchData() async {
    print("in fetchData start");
    String url =
        "https://newsapi.org/v2/top-headlines?language=en&apiKey=ddfed066567e46ee81438751ebb3029c";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("in fetchData middle");

    // log(data.toString());
    newsArticles.clear();
    data["articles"].forEach((article) {
      NewsArticle tempArticle = NewsArticle.dataFromMap(article);
      newsArticles.add(tempArticle);
    });
    // newsArticles.forEach((element) {
    //   element.printData();
    // });
    print("in fetchData end");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddCategories(categories);

    print("Categories length: ${categories.length}");

    var futureBuilder = FutureBuilder(
      builder: (context, snapshot) {
        print("in snapshot");
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done) {
          print("in builder");
          isLoading = false;
          setState(() {});
        } else {
          print("in builder");
          isLoading = false;
          setState(() {});
        }
        return CircularProgressIndicator();
        // setState(() { })
      },
      future: _fetchData(),
    );
    print("out od tuh");
    print(futureBuilder);
    // isLoading = false;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    print(DateTime.now());
  }

  void AddCategories(List<Category> categories) {
    categories.add(Category("Health"));
    categories.add(Category("Science"));
    categories.add(Category("Technology"));
    categories.add(Category("Education"));
    categories.add(Category("Politics"));
    categories.add(Category("Technology"));
    categories.add(Category("Education"));
    categories.add(Category("Politics"));
    // categories.add(Category("Health"));
  }

  void OnRefresh() {
    print("On Refresh()");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //PART3

    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widthPercent(context, 3.2),
        ),
        child: Column(
          children: [
            SearchWidget(context, this),
            Expanded(
              child: ListView(
                children: [
                  CategoryWidget(context, this),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      print("in snapshot");
                      print(snapshot.connectionState);
                      if (snapshot.connectionState != ConnectionState.done) {
                        print("in builder if ");
                        return Container(
                          padding: EdgeInsets.only(top: heightPercent(context, 30)),
                          child: LoadingAnimationWidget.inkDrop(
                            color: Colors.lightBlueAccent,
                            size: averagePercent(context, 10),
                          ),
                        );

                      } else {
                        print("in builder else");
                        return Container(
                          child: Column(
                            children: [
                              SliderWidget(context, this),
                              NewsWidget(context, this)

                            ],
                          ),
                        );
                      }
                      // setState(() { })
                    },
                    future: _fetchData(),
                  ),

                ],
              ),
            )

            // Row(
            //   children: [
            //     Expanded(
            //       child: Container(
            //           height: heightPercent(context, 15),
            //           width: widthPercent(context, 20),
            //           child: CategoryWidget(context, this)),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    ));
  }
}


Widget NewsWidget(BuildContext context, _HomeState home){
  return Container(
        height: heightPercent(context, 53),
        margin: EdgeInsets.only(top: heightPercent(context, 3)),
    child: ListView.builder(
      itemCount: home.newsArticles.length,
        itemBuilder: (context, index){
          if (home.newsArticles[index].isAnyNull()){
            return SizedBox(height: 0, width: 0,);
          }else{
          return InkWell(

            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    child: Image.network(home.newsArticles[index].imgUrl),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  Positioned(
                    left: 1,
                    bottom: 30,

                      child: FittedBox(child: Text(
                        home.newsArticles[index].title,
                        style: TextStyle(
                          letterSpacing: 2
                          // fontSize:
                        ),
                      )),
                  ),


                ],
              ),
            ),
          );}
        }),
  );

}

Widget SliderWidget(BuildContext context, _HomeState home) {
  return CarouselSlider(
      items: home.sliderItems.map((item) {
        return Builder(builder: (BuildContext context) {
          return Container(
            color: item,

          );
        });
      }).toList(),
      options: CarouselOptions(
        height: heightPercent(context, 20),
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlay: true,
        // autoPlayInterval: Duration(seconds: 0),
        // autoPlayAnimationDuration:
      ));
}

Widget CategoryWidget(BuildContext context, _HomeState home) {
  return SizedBox(
    height: heightPercent(context, 6),
    width: widthPercent(context, 100),
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: home.categories.length,
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: () {
              print("Category pressed");
              Colors.yellow;
            },
            child: Text(
              home.categories[index].name,
              style: TextStyle(
                fontSize: averagePercent(context, 2.5),
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        }),
  );
}

Widget SearchWidget(BuildContext context, _HomeState home) {
  return Container(
    //search container
    height: heightPercent(context, 6.5),
    width: widthPercent(context, 93.6),
    padding: EdgeInsets.symmetric(
      horizontal: widthPercent(context, 1.2),
    ),
    margin: EdgeInsets.only(
      // left: widthPercent(context, 3.2),
      // right: widthPercent(context, 3.2),
      top: heightPercent(context, 2),
      bottom: heightPercent(context, 1),
    ),

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).backgroundColor.withOpacity(.7),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(home.searchNode);
          },
          child: Container(
              margin: EdgeInsets.fromLTRB(
                  widthPercent(context, 1.2), 0, widthPercent(context, 1.7), 0),
              child: Icon(
                Icons.search,
                color: Colors.blue,
                size: averagePercent(context, 5),
              )),
        ),
        Expanded(
            child: TextField(
          style: TextStyle(
              // color: Colors.black,
              ),
          onTapOutside: (PointerDownEvent event) {
            home.searchNode.unfocus();
            print(event);
          },
          focusNode: home.searchNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (text) async {
            home.isLoading = true;
            print("Submitted");
            home.isLoading = false;
            // home.setState(() { });
          },
          controller: home.searchController,
          decoration: InputDecoration(
            hintText: "Lets cook something,",
            // hintStyle: TextStyle(
            //   color: Colors.black45,
            // ),
            border: InputBorder.none,
          ),
        )),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.only(right: widthPercent(context, 3)),
            child: Icon(
              Icons.refresh_outlined,
              size: averagePercent(context, 8),
              color: Colors.teal,
            ),
          ),
          onTap: home.OnRefresh,
        ),
      ],
    ),
  );
}
