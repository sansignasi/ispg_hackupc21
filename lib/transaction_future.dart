import 'package:flutter/material.dart';

class TransactionFuture extends StatelessWidget {
  const TransactionFuture({
    Key key,
    @required this.displayPrice
  });

  final String displayPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text("DOGE PRICE: \$$displayPrice",
            style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
            ),),
        ),
    );
  }
}
