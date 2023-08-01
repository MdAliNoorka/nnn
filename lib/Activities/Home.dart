import 'dart:convert';
import 'dart:developer';
import 'dart:math';

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
  List<NewsArticle> newsArticlesByCat = [];
  // List<String> Categores = ["business","entertainment","general","health","science","sports","technology"];

  // Future<void>
  Future<void> _fetchDataByLanguage({String lang = "en"}) async{
    String url =
        "https://newsapi.org/v2/top-headlines?language=$lang&apiKey=ddfed066567e46ee81438751ebb3029c";
    await _fetchData(url);
  }
  Future<void> _fetchDataByCategory({String cat = "null"}) async{
    categories.shuffle();
    newsArticlesByCat.clear();
    int length = 0;
    int page = 0;
    int categoryNumber = 0;
    bool changeCategory= false;
    do {
      page++;
      if (page > 5){
        // changeCategory = true;
        categoryNumber++;
        if(categoryNumber >= categories.length)
          break;
        page=1;
      }
      // print("fcat start");
      // Random random = Random();
      if (cat == "null") {
        cat = categories[categoryNumber].name;
        // print("cat $cat");
      }
      String url =
          "https://newsapi.org/v2/top-headlines?category=$cat&page=$page&apiKey=ddfed066567e46ee81438751ebb3029c";
      Response response = await get(Uri.parse(url));
      // print("fcat middle");

      Map data = jsonDecode(response.body);
      // // print("in fetchData middle");
      // print("fcat middle2");

      // log(data.toString());
      // print("fcat middle2");

      // List<Map> allArticles = data["articles"];
      // print("fcat middle2");

      for (int i =0 ; i< data["articles"].length; i++){
        // print("fcat middle for $i");

        NewsArticle tempArticle = NewsArticle.dataFromMap(data["articles"][i]);
        // // tempArticle.printData();
        if(tempArticle.isAnyNull()){
          continue;
        }
        newsArticlesByCat.add(tempArticle);
        // print(newsArticlesByCat.length);

      }
      // print("fcat end");

      // print(newsArticlesByCat.length);
      length = newsArticlesByCat.length;
    }while (length < 10);
    print("News articleByCat count: ${newsArticlesByCat.length}");
    // newsArticlesByCat.shu

    // data["articles"].forEach((article) {
    //   NewsArticle tempArticle = NewsArticle.dataFromMap(article);
    // // //   tempArticle.printData();
    //   if(tempArticle.isAnyNull()){
    //
    //   }
    //
    //   newsArticlesByCat.add(tempArticle);
    // });
    // newsArticles.forEach((element) {
    // // //   element.printData();
    // });
    // // print("in fetchData end");
  }


  Future<void> _fetchData(String url) async {
    // // print("in fetchData start");
    // String url =
    //     "https://newsapi.org/v2/top-headlines?language=en&apiKey=ddfed066567e46ee81438751ebb3029c";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    // // print("in fetchData middle");

    // log(data.toString());
    newsArticles.clear();
    // data["articles"].forEach((article) {
    //   NewsArticle tempArticle = NewsArticle.dataFromMap(article);
    //   newsArticles.add(tempArticle);
    // });
    // newsArticles.forEach((element) {
    // // //   element.printData();
    // });
    // // print("in fetchData end");

    // List<Map> data["articles"] = data["articles"];
    // print("fln middle");

    for (int i =0 ; i< data["articles"].length; i++){
      NewsArticle tempArticle = NewsArticle.dataFromMap(data["articles"][i]);
      // // tempArticle.printData();
      if(tempArticle.isAnyNull()){
        continue;
      }
      newsArticles.add(tempArticle);
      // print(newsArticles.length);

    }
    print("News article count: ${newsArticles.length}");
    newsArticles.shuffle();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddCategories(categories);

    // // print("Categories length: ${categories.length}");


    // // print("out od tuh");
    // isLoading = false;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    // // print(DateTime.now());
  }

  void AddCategories(List<Category> categories) {
    categories.add(Category("business"));
    categories.add(Category("entertainment"));
    categories.add(Category("technology"));
    categories.add(Category("general"));
    categories.add(Category("health"));
    categories.add(Category("science"));
    categories.add(Category("sports"));
  }

  void OnRefresh() {
    // // print("On Refresh()");
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
                      // // print("in snapshot");
                      // // print(snapshot.connectionState);
                      if (snapshot.connectionState != ConnectionState.done) {
                        // // print("in builder if ");
                        return Container(
                          padding: EdgeInsets.only(top: heightPercent(context, 30)),
                          child: LoadingAnimationWidget.inkDrop(
                            color: Colors.lightBlueAccent,
                            size: averagePercent(context, 10),
                          ),
                        );

                      } else {
                        // // print("in builder else");
                        return  Container(
                          // height: heightPercent(context, 100),
                          // margin: EdgeInsets.only(top: heightPercent(context, 2.5), bottom: heightPercent(context, 3.5)),
                          // padding: EdgeInsets.only(top: heightPercent(context, 2.5), bottom: heightPercent(context, 3.5)),
                                // SliderWidget(context, this),
                          child:      NewsWidget(context, this)

                        );

                      }
                      // setState(() { })
                    },
                    future: _fetchDataByLanguage(),
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
        height: heightPercent(context, 75),
        margin: EdgeInsets.only(top: heightPercent(context, 3), bottom: heightPercent(context, 3)),
    child: ListView.builder(
      padding: EdgeInsets.only(bottom: heightPercent(context, 0)),
      itemCount: home.newsArticles.length + 1,
        itemBuilder: (context, index){
        if(index == 0){
         return FutureBuilder(
           builder: (context, snapshot) {
             // // print("in snapshot");
             // // print(snapshot.connectionState);
             if (snapshot.connectionState != ConnectionState.done) {
               // // print("in builder if ");
               return Container(
                 padding: EdgeInsets.only(top: heightPercent(context, 7)),
                 child: LoadingAnimationWidget.inkDrop(
                   color: Colors.lightBlueAccent,
                   size: averagePercent(context, 10),
                 ),
               );

             } else {
               // // print("in builder else");
               return      SliderWidget(context, home);


             }
             // setState(() { })
           },
           future: home._fetchDataByCategory(),
         );
        }
        else if (home.newsArticles[index-1].isAnyNull()){
            return SizedBox(height: 0, width: 0,);
          }else{
          // print("NewsFound");
          return Container(
            padding: EdgeInsets.only(bottom: heightPercent(context, 1.3)),
            child: InkWell(

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      child: Image.network(home.newsArticles[index-1].imgUrl, fit: BoxFit.cover,),
                      borderRadius: BorderRadius.circular(20),

                    ),
                    Positioned(
                      left: 1,
                      bottom: 30,

                        child: FittedBox(child: Text(
                          home.newsArticles[index-1].title,
                          style: TextStyle(
                            letterSpacing: 2
                            // fontSize:
                          ),
                        )),
                    ),


                  ],
                ),
              ),
            ),
          );}
        }),
  );

}

Widget SliderWidget(BuildContext context, _HomeState home) {
  return Container(
    padding: EdgeInsets.only(bottom: heightPercent(context, 3)),
    child: CarouselSlider(
        items: home.newsArticlesByCat.map((article) {
          if (article.isAnyNull()){
            return SizedBox(height: 0, width: 0,);
          }
          return Builder(builder: (BuildContext context) {
            return InkWell(

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      child: Image.network(article.imgUrl, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // Positioned(
                    //   left: 1,
                    //   bottom: 30,
                    //
                    //   child: FittedBox(child: Text(
                    //     article.title,
                    //     style: TextStyle(
                    //         // letterSpacing: 2
                    //       fontSize: averagePercent(context, 1),
                    //     ),
                    //   )),
                    // ),


                  ],
                ),
              ),
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
        )),
  );

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
              // // print("Category pressed");
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
            // // print(event);
          },
          focusNode: home.searchNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (text) async {
            home.isLoading = true;
            // // print("Submitted");
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
