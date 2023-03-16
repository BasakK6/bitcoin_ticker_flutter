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
  Future<Map<String, String>> getCoinData(
      {required String currencyType}) async {
    Map<String, String> cryptoRates = {};

    for (String cryptoType in cryptoList) {
      String url = "$apiUrl/$cryptoType/$currencyType?apiKey=$apiKey";
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String jsonString = response.body;
        var data = jsonDecode(jsonString);
        double rate = data["rate"];
        cryptoRates[cryptoType] = rate.toStringAsFixed(2);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }

    return cryptoRates;
  }
}
