import 'package:flutter/material.dart';
import 'package:parcial2/Models/currencies.dart';
import 'package:parcial2/Provider/provider.dart';


class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController =
      TextEditingController(); /*Se crea la variable asignandole el TextEditingController para poder usar el controller de un TextField*/
  // ignore: prefer_typing_uninitialized_variables
  var currencies; /*Aca se guardaran todas las monedas*/
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  // ignore: prefer_typing_uninitialized_variables
  var result;
  var prov;

  @override
  void initState() {
    super.initState();

    final getProvider = CurrenciesProvider();

    prov = getProvider;

    currencies = getProvider.getJSONData();
  }

 _onFromChanged(String value) {
    setState(() {
      fromCurrency = value; /*Muestra la divisa escogida*/
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value; /*Muestra la divisa escogida*/
    });
  }

  _prueba() {
    setState(() {
      result =
          prov.doConversion(fromCurrency, toCurrency, fromTextController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 105, 132, 175),
      // ignore: unnecessary_null_comparison
      body: FutureBuilder(
          future: currencies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 18.0),
                    child: snapshot.data ==
                            null /*Como los datos tardan en cargar y la interfaz de usuario carga antes que las divisas se llamen, entonces hacemos una validacion de que si las divisas son nulas ejecute el resto del scaffold lo que hara que cargue la interfaz en conjunto con los datos*/
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ignore: sized_box_for_whitespace
                                Container(
                                  width: double.infinity,
                                  height: 250,
                                  child:
                                      Image.asset('assets/icono_proyecto.png'),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ListTile(
                                          title: TextField(
                                            decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    204, 243, 239, 239),
                                                labelText: "Convertir",
                                                labelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 18.0,
                                                    color: Color.fromARGB(
                                                        255, 136, 163, 206))),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: fromTextController,
                                            /*Ejecuta una funcion de tipo callback cada vez que cambia el texto*/
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal:
                                                    true), /*El teclado se muestra numerico y acepta decimales*/
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildDropDownButton(
                                                  fromCurrency),
                                              /*Llamamos la funcion con el parametro de fromCurrency que es "DE"(From)* haciendo que el valor predeterminado sea USD*/
                                              FloatingActionButton(
                                                  onPressed: _prueba,
                                                  child: const Icon(Icons
                                                      .arrow_downward_sharp),
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 61, 3, 168)),
                                              _buildDropDownButton(
                                                  toCurrency), /*Llamamos la funcion con el parametro de fromCurrency que es "A"(To) haciendo que el valor predeterminado sea GBP*/
                                            ]),
                                        const SizedBox(height: 50.0),
                                        Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16.0),
                                            margin: const EdgeInsets.only(
                                                left: 18.0, right: 18.0),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  204, 243, 239, 239),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: FutureBuilder(
                                              future: result,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  var re =
                                                      snapshot.data as String;
                                                  return Column(children: [
                                                    ListTile(
                                                      title: Chip(
                                                        /*Genera un rectangulo redondeado de fondo*/
                                                        label: re != null
                                                            ? /*Si resultado es diferente de null ejectua el resultado, sino muestrame un texto en blanco*/
                                                            Text(
                                                                re,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displaySmall,
                                                              )
                                                            : const Text(""),
                                                      ),
                                                    ),
                                                  ]);
                                                } else {
                                                  return const Text('');
                                                }
                                              },
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
              );
            } else {
              return const Text('Hubo un Error');
            }
          }),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    /*Coge como argumento si el valor de la categoria es DE(From) o A(To)*/
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
        margin: const EdgeInsets.only(left: 18.0, right: 18.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(204, 243, 239, 239),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: FutureBuilder(
          future: currencies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var a = snapshot.data as CurrenciesModel;

              var b = a.getExchanges.keys.toList();

              return DropdownButton(
                value: currencyCategory,
                /*Hace que se dibuje la divisa en el boton*/

                items: b
                    .map<DropdownMenuItem<String>>(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        /*Valor actual de la iteracion*/
                        child: Row(
                          children: <Widget>[
                            Text(value),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  /*Le damos al value un valor de String*/
                  if (currencyCategory == fromCurrency) {
                    _onFromChanged(
                        value!); /*Obtiene la divisa presentada en el boton y la muestra*/
                  } else {
                    _onToChanged(
                        value!); /*Obtiene la divisa presentada en el boton y la muestra*/
                  }
                },
              );
            } else {
              return const Text('no sirve');
            }
          },
        ));
  }
}