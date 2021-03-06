import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Exercise 2', key: null,),
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

  Future<String> getJSONData() async {
    var response = await http.get(
      // Encode the url
        Uri.parse("https://api.json-generator.com/templates/Xp8zvwDP14dJ/data?access_token=v3srs6i1veetv3b2dolta9shrmttl72vnfzm220z"),
        // Only accept JSON response
        headers: {
          "Accept": "application/json"
             }
    );

    setState(() {
      // Get the JSON data
      data = json.decode(response.body.toString());
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
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildImageColumn(data[index]);
        }
    );
  }

  Widget _buildImageColumn(dynamic item) => Container(
    decoration: const BoxDecoration(
        color: Colors.white54
    ),
    margin: const EdgeInsets.all(4),
    child: Column(
      children: [
        CachedNetworkImage(
          imageUrl: item['picture'],
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
        item['name']['first'] + " " + item['name']['last'],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Detail(picture: item['picture'], first: item['name']['first'], last: item['name']['last'], email: item['email'], latitude: item['location']['latitude'], longitude: item['location']['longitude'] )),
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    getJSONData();
  }
}

class Detail extends StatelessWidget {
  final String picture;
  final String first;
  final String last;
  final String email;
  final double latitude;
  double? longitude;

  Detail({required this.picture, required this.first, required this.last, required this.email, required this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    longitude ??= 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Column(
        children: <Widget>[
      Expanded(
          child: FlutterMap(
                  options: MapOptions(
                  center: LatLng(latitude, longitude!),
                  zoom: 13.0,
                  ),
          layers: [
                  TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']
                    ),
                  MarkerLayerOptions(
                    markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(latitude, longitude!),
                    builder: (ctx) =>
                  Container(
                    child: const FaIcon
                  (
                    FontAwesomeIcons.mapPin,
                    color: Colors.deepOrange,
                    size: 35,
                  )
                  ),
                  ),
                  ],
                  ),
                  ],
                  ),),

          Row (
          children: [Image.network(
            picture,
            width: 50,
            height: 50,
          ),

            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("${first} ${last}"),
                          Text("${email}"),]),
          ]),

          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ),
        ],
      ),
    );
  }
}