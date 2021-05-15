import 'package:flutter/material.dart';
import 'package:ispghackupc21/body.dart';

import 'package:twitter_api/twitter_api.dart'; //used for sentiment analysis


void main() => runApp(MaterialApp(
  home: Home(),
));


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