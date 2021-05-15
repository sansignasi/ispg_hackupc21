import 'package:flutter/material.dart';
import 'package:ispghackupc21/services/crypto_data.dart';
import 'package:ispghackupc21/transaction_future.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String displayPrice = '';
  double data;

  void getData() async{
    try{
      data = await CoinData().getCryptoData();
      setState(() {
        displayPrice = data.toString();
        print(displayPrice);
      });
    }catch (e){
      print(e);
    }
  }

  Future searchTweets(String query) async {
    setState(() {
      isLoading = true;
    });

  void getClass() async{
    try{
      // Make the request to twitter
      var query = 'Dogecoin'


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
        print(tweets)

        for (int i = 0; i < tweets['statuses'].length; i++) {//look through every collected tweet
          var idValue = tweets['statuses'][i]['full_text'];//Full text of the tweet
          Map tweetValues = sentiment.analysis(idValue, emoji: true, languageCode: 'en');//run sentiment analysis of full text
          tweet curTweet = new tweet(idValue, tweetValues['score'],query);//create new tweet object for TweetCollection
          if(tweetValues['badword'] != null) {
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
    }
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
        Expanded(child: TransactionFuture(displayPrice: displayPrice)),
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
                icon: const Icon(Icons.refresh, size: 40,),
                label: Text('Refresh', style: TextStyle(fontSize: 20),),
                backgroundColor: Colors.cyan,
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
