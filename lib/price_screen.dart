import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "AUD";
  String coinVsCurrencyRate = "?";
  Map<String, String> cryptoRates = {};
  bool isLoading = false;

  DropdownButton<String> getAndroidDropdown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getCoinRate();
        });
      },
      items: currenciesList
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList(),
    );
  }

  CupertinoPicker getIOSPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCoinRate();
        });
      },
      children: currenciesList.map((e) => Text(e)).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    getCoinRate();
  }

  void updateLoadingStatus() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void getCoinRate() async {
    try {
      updateLoadingStatus();
      var data = await CoinData().getCoinData(currencyType: selectedCurrency);
      setState(() {
        cryptoRates = data;
      });
    } catch (e) {
      print(e);
    } finally {
      updateLoadingStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList
                .map(
                  (e) => CryptoCard(
                    cryptoType: e,
                    coinVsCurrencyRate:
                        isLoading ? "?" : (cryptoRates[e] ?? "?"),
                    selectedCurrency: selectedCurrency,
                  ),
                )
                .toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.coinVsCurrencyRate,
    required this.selectedCurrency,
    required this.cryptoType,
  });

  final String cryptoType;
  final String coinVsCurrencyRate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoType = $coinVsCurrencyRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
