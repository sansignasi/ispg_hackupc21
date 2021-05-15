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
