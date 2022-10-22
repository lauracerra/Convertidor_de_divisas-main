class Currencies {
  var curr;

  Currencies();

  Currencies.add(json) {
    if (json == null) return;

    final model = CurrenciesModel.fromJsonMap(json);

    curr = model;
  }
}

class CurrenciesModel {
  late Map rates;

  CurrenciesModel(this.rates);

  CurrenciesModel.fromJsonMap(json) {
    rates = json['rates'];
  }

  Map get getExchanges {
    return rates;
  }
}
