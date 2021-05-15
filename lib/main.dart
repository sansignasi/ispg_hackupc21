import 'package:flutter/material.dart';
import 'package:ispghackupc21/body.dart';
import 'package:sentiment_dart/sentiment_dart.dart'; //used for sentiment analysis


void main() => runApp(MaterialApp(
  home: Home(),
));

  static String consumerApiKey = "QxGBbMkqvT29TlZs3LM2gsChf";
  static String consumerApiSecret = "ZnNZB5mWPT2MJ7yna5H7AiwJMUmwuuuOywLtZ9vcAoebDEmRHm";
  static String accessToken = "585185817-oEm0MCrRF6LnxYSOvWm9JmKAsb436Pf3mcrECnIG";
  static String accessTokenSecret = "pHIlNJAF89YwilMi9YeJsBfHZwhXk3EuwWhwWVXc3imS2";

  final _twitterOauth = new twitterApi(//key information requered for requests to the twitter api
      consumerKey: consumerApiKey,
      consumerSecret: consumerApiSecret,
      token: accessToken,
      tokenSecret: accessTokenSecret
  );

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dogecoin HyPredict', style: TextStyle(fontSize: 30)),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Body(),
    );
  }
}

//a list of CoinDataPoint instances between from Date and to Date