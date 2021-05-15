import 'dart:convert';

import 'package:http/http.dart' as http;

String apirUrl =
    "https://api.coingecko.com/api/v3/simple/price?ids=dogecoin&vs_currencies=usd";

class CoinData {
  Future getCryptoData() async {
    final response = await http.get(
      apirUrl,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var dogePrice = decodedData["dogecoin"]["usd"];
      return dogePrice;
    } else {
      print(response.statusCode);
      throw "There was an error with the request";
    }
  }
}