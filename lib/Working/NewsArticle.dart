import 'package:flutter/material.dart';
class NewsArticle{
  late String imgUrl;
  late String articleUrl;
  late String title;
  late String description;

  NewsArticle({this.title = "null", this.description = "null", this.articleUrl = "null", this.imgUrl = "null" });

  NewsArticle.dataFromMap(Map article){
    imgUrl = article["urlToImage"].toString();
    // print(imgUrl);
    title =  article["title"].toString();
    // print(title);

    description =  article["description"].toString();
    // print(description);
     articleUrl =  article["url"].toString();
     // print(articleUrl);
     // printData();
  }
  bool isAnyNull() {
    return (title == "null" || description == "null" || articleUrl == "null" || imgUrl == "null"  );
  }
  printData(){
    print("title: $title\n description: $description \n articleUrl: $articleUrl \n imgUrl: $imgUrl");
  }



}