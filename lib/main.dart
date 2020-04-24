import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'header.dart';
import 'constants.dart';

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
      home: CovidData(),
    );
  }
}

class CovidData extends StatefulWidget {
  @override
  _CovidState createState() => _CovidState();
}

class _CovidState extends State<CovidData> {
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
    return Scaffold(
        body: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: <Widget>[
                MyHeader(
                  image: "assets/icons/Drcorona.svg",
                  textTop: "All you need to do",
                  textBottom: "is stay at home.",
                  offset: offset,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Last Updated\n",
                                  style: kTitleTextstyle,
                                ),
                                TextSpan(
                                  text: Text(data[0]["lastupdatedtime"]).data,
                                  style: TextStyle(
                                    color: kTextLightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: Text(data[0]["active"]).data,
                              title: "Active",
                            ),
                            Counter(
                              color: kDeathColor,
                              number: Text(data[0]["deaths"]).data,
                              title: "Deaths",
                            ),
                            Counter(
                              color: kRecovercolor,
                              number: Text(data[0]["recovered"]).data,
                              title: "Recovered",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            )));
    /*
        Expanded(child:
        ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(data[index]["active"],
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.black54)),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(data[index]["confirmed"],
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.black54)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ))*/
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
