import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:parcial2/Models/currencies.dart'; /*Paquete para obtener datos de internet*/

class CurrenciesProvider {
  var url = Uri.parse("https://api.frankfurter.app/latest");

  Future getJSONData() async {
    var response =
        await http.get((url), headers: {"Accept": "application/json"});
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    final exchanges = Currencies.add(jsonData);
    print(exchanges);
    return exchanges.curr;
  }

  Future<String> doConversion(fromCurrency, toCurrency, text) async {
    var url = Uri.parse(
        "https://api.frankfurter.app/latest?amount=1&from=$fromCurrency&to=$toCurrency"); /*Se modifica la url ya que venia predeterminada con dos divisas y en cambio se colocan las dos variables que cambian sus divisas cuando son escogidas en el boton desplegable para ser mas dinamico*/
    var response =
        await http.get((url), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);

    var result = (double.parse(text) * (responseBody["rates"][toCurrency]))
        .toString(); /*Se usa el double.parse ya que examina las cadenas de Texto y busca los numeros de punto flotante*/ /*Para posteriormente pasar de nuevo a un String*/
    /*Esta variable lo que hara es mostrarnos el cambio de divisa que querremos por eso se ace con toCurrency porque es la divisa resultante de la cual queremos saber su valor respecto a una divisa inicial*/
    // ignore: avoid_print
    print(result);
    return result;
  }
}
