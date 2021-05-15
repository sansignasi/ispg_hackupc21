import 'package:flutter/material.dart';
import 'package:ispghackupc21/body.dart';
import 'package:sentiment_dart/sentiment_dart.dart'; //used for sentiment analysis


void main() => runApp(MaterialApp(
  home: Home(),
));
/*
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
  // Make the request to twitter
  var query = 'Dogecoin'
  Future searchTweets(String query) async {
    setState(() {
      isLoading = true;
    });

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
    },
  );
  // Wait for the future to finish
  var res = await twitterRequest;//result of the API request

  // Print off the response
  //print(res.statusCode);
  List<tweet> tweetList = new List();//list to hold all tweets
  // Convert the string response into something more useable
  var tweets = json.decode(res.body);//decode the response from the API

  for (int i = 0; i < tweets['statuses'].length; i++) {//look through every collected tweet
    var idValue = tweets['statuses'][i]['full_text'];//Full text of the tweet
    Map tweetValues = sentiment.analysis(idValue, emoji: true, languageCode: 'en');//run sentiment analysis of full text
    tweet curTweet = new tweet(idValue, tweetValues['score'],query);//create new tweet object for TweetCollection
    if(tweetValues['badword'] != null)
    {
      for(int i=0; i<tweetValues['badword'].length; i++){
        if(query.contains(tweetValues['badword'][i][0].toString())) { //search word won't show up in list of bad words
          continue;
        }
        curTweet.setArray(tweetValues['badword'][i][0], tweetValues['badword'][i][1], 0); //add as a negative word used
      }
    }
    if(tweetValues['good words'] != null) {
      for (int i = 0; i < tweetValues['good words'].length; i++) {
        if (query.contains(tweetValues['good words'][i][0].toString())) {//search word wont show up in list of good words
          continue;
        }
        curTweet.setArray(tweetValues['good words'][i][0], tweetValues['good words'][i][1], 1);//add as a positive word used
      }
    }
    tweetList.add(curTweet);//all tweet data collect add to list to display in next pager
  }
*/
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