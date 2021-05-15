import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ispghackupc21/services/crypto_data.dart';
import 'package:ispghackupc21/transaction_future.dart';
import 'package:ispghackupc21/tweet.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
import 'package:twitter_api/twitter_api.dart';
import 'package:intl/intl.dart';
import "dart:math" as m;


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String displayPrice = '';
  double data;
  final sentiment = Sentiment();
  bool isLoading = false;
  String hypeLevel = '3';
  double a = 2.0;
  double b = 1.0;
  double lambda = 0.01;

  void getData() async{
    try{
      data = await CoinData().getCryptoData();
      setState(() {
        displayPrice = data.toString();
      });
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String today = formatter.format(now);
      List l = await searchTweets('Dogecoin','');
      int pred = await compute_approx();
      make_face(getElonClass(l).toInt(), pred);
      setImage();
      setState(() {
      });
    }catch (e){
      print(e);
    }
  }

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

  Future<List> searchTweets(String query, String d) async {
    setState(() {
      isLoading = true;
    });
    // Make the request to twitter
    Future twitterRequest = _twitterOauth.getTwitterRequest(
      // Http Method
      "GET",//GET request
      // Endpoint you are trying to reach
      "search/tweets.json",
      // The options for the request
      options: {
        "q": query,
        "lang": "en",//english
        "count":"100",//100 tweet Max amount for free
        "tweet_mode": "extended",// Used to prevent truncating tweets
        "until": d,
      },
    );
    // Wait for the future to finish
    var res = await twitterRequest;//result of the API request

    // Print off the response
    //print(res.statusCode);
    List<tweet> tweetList = new List();//list to hold all tweets
    // Convert the string response into something more useable
    var tweets = json.decode(res.body);//decode the response from the API

    for (int i = 0; i < tweets['statuses'].length; i++) { //look through every collected tweet
      var idValue = tweets['statuses'][i]['full_text']; //Full text of the tweet
      var customLang = {'buy': 2, 'hold': 1, 'hodl':1, 'accept':2, 'reject': -2, 'moon':4, 'sell':-2, 'scam': -3};
      Map tweetValues = sentiment.analysis(idValue, emoji: true,
          languageCode: 'en',customLang: customLang); //run sentiment analysis of full text
      tweet curTweet = new tweet(idValue, tweetValues['score'],
          query); //create new tweet object for TweetCollection
      if (tweetValues['badword'] != null) {
        for (int i = 0; i < tweetValues['badword'].length; i++) {
          if (query.contains(tweetValues['badword'][i][0]
              .toString())) { //search word won't show up in list of bad words
            continue;
          }
          curTweet.setArray(
              tweetValues['badword'][i][0], tweetValues['badword'][i][1],
              0); //add as a negative word used
        }
      }
      if (tweetValues['good words'] != null) {
        for (int i = 0; i < tweetValues['good words'].length; i++) {
          if (query.contains(tweetValues['good words'][i][0]
              .toString())) { //search word wont show up in list of good words
            continue;
          }
          curTweet.setArray(
              tweetValues['good words'][i][0], tweetValues['good words'][i][1],
              1); //add as a positive word used
        }
      }
      tweetList.add(
          curTweet); //all tweet data collect add to list to display in next pager
    }
    return tweetList;
  }

  void make_face(real, pred){
    double perc = ((real-pred)/pred)*100;
    if (perc < 0){
      if (perc < -50)  hypeLevel='1';
      else if (perc < -25) hypeLevel='2';
      else hypeLevel='3';
    }
    else {
      if (perc > 50)
        hypeLevel = '5';
      else if (perc > 25)
        hypeLevel = '4';
      else
        hypeLevel = '3';
    }
  }

  initialize_parameters(){
    a = 2.0;
    b = 1.0;
    lambda = 0.01;
  }

  double forward(double X) => this.a*X + this.b;
  double mse(double Y, double Y_hat) => m.pow(Y-Y_hat, 2);

  double dmseda(double X, double Y, double Y_hat) => -2*(Y-Y_hat)*X;
  double dmsedb(double Y, double Y_hat) => -2*(Y-Y_hat);

  void step(double X, double Y) {
    var Y_hat = this.forward(X);
    var mse = this.mse(Y, Y_hat);
    var dLda = this.dmseda(X, Y, Y_hat);
    var dLdb = this.dmsedb(Y, Y_hat);
    this.a = this.a - this.lambda*dLda;
    this.b = this.b - this.lambda*dLdb;
  }

  void fit(List<double> X, List<double> Y, int n_iter) {
    var n = X.length;
    for (var j = 0; j <= n_iter; j++) {
      for (var i = 0; i <= n-1; i++) {
        this.step(X[i], Y[i]);
      }
    }
  }

  Future<int> compute_approx() async{
    List<double> v_dies = [];
    for(int i=1; i < 7; ++i){
      DateTime today = DateTime.now();
      DateTime day_i = today.subtract(Duration(days: i));
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(day_i);
      List l = await searchTweets('Dogecoin', formatted);
      v_dies.add(getElonClass(l));
    }
    initialize_parameters();
    List rev = [];
    for(int j=v_dies.length-1; j>=0; --j){
      rev.add(v_dies[j]);
    }
    List<double> dies = [1,2,3,4,5,6];
    fit(dies,v_dies,20);
    double ret = await forward(7.0);
    return ret.toInt();
  }

  double getElonClass(tweetList){
    double suma = 0;
    for (int i=0; i<tweetList.length; ++i){
      suma += tweetList[i].get_value();
    }
    return suma;
  }

  String setImage() {
    if(hypeLevel == '1') {
      return "assets/1.png";
    } else if(hypeLevel == '2') {
      return "assets/2.png";
    } else if(hypeLevel == '3') {
      return "assets/3.png";
    } else if(hypeLevel == '4') {
      return "assets/4.png";
    } else return "assets/5.png";
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      getData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return displayPrice.isNotEmpty ? Column(
      children: [
        Container(
          child: Image(
            image: AssetImage(setImage()),
          ),
          height: 400,
          margin: const EdgeInsets.only(top: 30),
        ),
        Expanded(child: TransactionFuture(displayPrice: displayPrice, hypeLevel: hypeLevel,)),
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
                icon: const Icon(Icons.refresh, size: 40,),
                label: Text('Refresh', style: TextStyle(fontSize: 20),),
                backgroundColor: Colors.pinkAccent,
                focusColor: Colors.cyanAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                onPressed: () async {
                  data = await CoinData().getCryptoData();
                  setState(() {
                    getData();
                  });
                }
            ),
          )
        )
      ],
    ) : Center(
      child: CircularProgressIndicator(),
    );
  }
}
