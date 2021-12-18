import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', key: null,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List data =[];

  // Function to get the JSON data
  Future<String> getJSONData() async {
    var response = await http.get(
      // Encode the url
        Uri.parse("https://api.json-generator.com/templates/Xp8zvwDP14dJ/data?access_token=v3srs6i1veetv3b2dolta9shrmttl72vnfzm220z"),
        // Only accept JSON response
        headers: {
      //    HttpHeaders.authorizationHeader: '"access_token":  "v3srs6i1veetv3b2dolta9shrmttl72vnfzm220z"',
          "Accept": "application/json"
             }

     //   Uri.parse("https://unsplash.com/napi/photos/Q14J2k8VE3U/related"),
    // Only accept JSON response
    //    headers: {"Accept": "application/json"}
    );
  print (response.body);
    setState(() {
      // Get the JSON data
      data = json.decode(response.body.toString());
      //['_id'];
    });

    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (context, index) {
          return _buildImageColumn(data[index]);
          // return _buildRow(data[index]);
        }
    );
  }

  Widget _buildImageColumn(dynamic item) => Container(
    decoration: BoxDecoration(
        color: Colors.white54
    ),
    margin: const EdgeInsets.all(4),
    child: Column(
      children: [
        new CachedNetworkImage(
          imageUrl: item['picture'],
      //    imageUrl: item['urls']['small'],
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          fadeOutDuration: new Duration(seconds: 1),
          fadeInDuration: new Duration(seconds: 3),
        ),
        _buildRow(item)
      ],
    ),
  );

  Widget _buildRow(dynamic item) {
    return ListTile(
      title: Text(
        item['name']['last'] == null ? '': item['name']['last'],
     //   item['description'] == null ? '': item['description'],
      ),
      subtitle: Text("Likes: " + item['likes'].toString()),
    );
  }
  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    this.getJSONData();
  }
}