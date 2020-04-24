import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'header.dart';
import 'constants.dart';

class CovidView extends StatefulWidget {
  @override
  _CovidView createState() => _CovidView();
}

class _CovidView extends State<CovidView> {
  final controller = ScrollController();
  double offset = 0;

  final String url = "https://api.covid19india.org/data.json";
  List data;

  Future<String> getCovidData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody["statewise"];
    });

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: Colors.black12,
      appBar: new AppBar(
        title: Text("Spread", style: TextStyle(color: Colors.white, fontFamily: 'BalooBhaina2')),
        backgroundColor: Colors.transparent,
              elevation: 0.0,
      ),
      body: Column(children: <Widget>[
      
      Expanded(
          child: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              padding: EdgeInsets.all(10.0),
              child: Card(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data[index]["state"],
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black54)),
                              Text(data[index]["confirmed"],
                                  style: new TextStyle(
                                      fontSize: 30.0, color: Colors.black87, fontFamily: 'BalooBhaina')),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Active",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black54)),
                                  Text(data[index]["active"],
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black87)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text("Deaths",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black54)),
                                  Text(data[index]["deaths"],
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black87)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Recovered",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black54)),
                                  Text(data[index]["recovered"],
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black87)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ))));
        },
      ))
    ]));
  }

  @override
  void initState() {
    super.initState();
    this.getCovidData();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class Counter extends StatelessWidget {
  final String number;
  final Color color;
  final String title;
  const Counter({
    Key key,
    this.number,
    this.color,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$number",
          style: TextStyle(
            fontSize: 40,
            color: color,
          ),
        ),
        Text(title, style: kSubTextStyle),
      ],
    );
  }
}
