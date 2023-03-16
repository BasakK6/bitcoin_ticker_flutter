import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String apiKey = "E5DA8BDD-CC71-4B0C-8A7C-8A86129ACB5B";
const String apiUrl = "https://rest.coinapi.io/v1/exchangerate";

class CoinData {
  String coinType = "BTC";
  String currencyType = "USD";

  Future<double> getCoinData() async {
    String url = "$apiUrl/$coinType/$currencyType?apiKey=$apiKey";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String jsonString = response.body;
      var data = jsonDecode(jsonString);
      double rate = data["rate"];
      return rate;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
