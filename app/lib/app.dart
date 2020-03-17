import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyApp extends StatefulWidget
{
  AppState createState(){
    return AppState();
  }
}

class Images
{
  int id;
  String url;
  String title;

  Images(this.id, this.url, this.title);

  Images.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['id'];
    url = parsedJson['url'];
    title = parsedJson['title'];
  }
}

class AppState extends State<MyApp>
{
  int count = 0;

  Future<List<Images>> fetchImage() async {
    var result = await http.get('https://jsonplaceholder.typicode.com/photos/');
    var images = json.decode(result.body);

    List<Images> imgs = [];
    
    for(var i in images){
      Images img = Images(i["id"], i["url"], i["title"]);

      imgs.add(img);
    }
  
    return imgs;
  }

  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Let's See Images")
        ),
        body: Container(
          child: FutureBuilder(
            future: fetchImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(color: Colors.white),
                itemCount: count,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Image.network(
                      snapshot.data[index].url
                    ),
                    subtitle: Text(snapshot.data[index].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, height: 1.5)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                  );
                }
              );
            }, 
          ),
        ),
        backgroundColor: Colors.blueGrey,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState((){
              count++;
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}