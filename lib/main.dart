import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http; /*Paquete para obtener datos de internet*/

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Convertidor",
    home: CurrencyConverter(),
  ));
}

class CurrencyConverter extends StatefulWidget {
 const CurrencyConverter({Key? key}) : super(key: key);

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  Color  mainColor = const Color(0xFF212936);
  Color  secondColor = const Color(0xFF2849E5);
  final fromTextController =  TextEditingController(); /*Se crea la variable asignandole el TextEditingController para poder usar el controller de un TextField*/
  // ignore: prefer_typing_uninitialized_variables
  var currencies; /*Aca se guardaran todas las monedas*/
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  // ignore: prefer_typing_uninitialized_variables
  var result;

  @override
  void initState(){
    super.initState();
     _getJSONData();   /*Creamos el metodo para cargar las divisas, el cual tomara los datos del punto final, siendo que cada vez que desee obtener datos de un punto final, las pilas que pueden tardar un poco en completarse entonces para evitar esto se realizara de manera async*/
     /*A su vez Una vez se inizialicien los widgets se llamara una vez, lo que significa que la aplicacion deberia cargar todas las autorizaciones*/
     
  }

  // ignore: unused_element
  Future<String> _getJSONData() async{ /*La carga de monedas devolvera una cadena, por lo que se usa el Future, porque el Future tiene una propiedad que que le dice a la funcion que la cadena la devolvera en el futuro, por lo que no la devolvera de inmediato*/
    var url = Uri.parse("https://api.frankfurter.app/latest");
    var response = await http.get((url), headers: {"Accept": "application/json"}); /*Usando el metodo http.get obtendremos una muestra de la API. Como http.get no puede trabajar con cadenas anteriormente en la variable url se utiliza URI.parse para analizar la direccion HTTP*/
    var responseBody= json.decode(response.body); /*Se extrae el cuerpo de respuesta obteniendo los datos en formato JSON*/
    Map curMap = responseBody['rates']; /*Aqui filtraremos lo que nos envia de la API para que solo nos muestre los 'rates' o sea las divisas unicamente y no toda la lista de String*/
    /*La razon por la que se usa Map es que arroja un par de valores de key y valor o sea la divisa y cuanto cuesta*/
    currencies = curMap.keys.toList(); /*Convertimos los datos en una Lista de valores*/
    setState(() {
        /*Una vez se haga la validacion en el body cambia el estado y muestra la interfaz*/
      });
    // ignore: avoid_print
    print(currencies); 
    return "Success";
  }

  // ignore: unused_element
  Future<String> _doConversion() async {
    var url = Uri.parse("https://api.frankfurter.app/latest?amount=10&from=$fromCurrency&to=$toCurrency"); /*Se modifica la url ya que venia predeterminada con dos divisas y en cambio se colocan las dos variables que cambian sus divisas cuando son escogidas en el boton desplegable para ser mas dinamico*/
    var response = await http.get((url), headers: {"Accept": "application/json"});
    var responseBody= json.decode(response.body);
    setState(() {
    result = (double.parse(fromTextController.text) * (responseBody["rates"][toCurrency])).toString(); /*Se usa el double.parse ya que examina las cadenas de Texto y busca los numeros de punto flotante*/ /*Para posteriormente pasar de nuevo a un String*/
    }); /*Esta variable lo que hara es mostrarnos el cambio de divisa que querremos por eso se ace con toCurrency porque es la divisa resultante de la cual queremos saber su valor respecto a una divisa inicial*/
    // ignore: avoid_print
    print(result);
    return "Success";
  }

  _onFromChanged(String value){
    setState(() {
      fromCurrency = value; /*Muestra la divisa escogida*/
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value; /*Muestra la divisa escogida*/  
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: mainColor,
      // ignore: unnecessary_null_comparison
      body: 
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: currencies == null /*Como los datos tardan en cargar y la interfaz de usuario carga antes que las divisas se llamen, entonces hacemos una validacion de que si las divisas son nulas ejecute el resto del scaffold lo que hara que cargue la interfaz en conjunto con los datos*/ 
          ? const Center(child: CircularProgressIndicator()) :
          SizedBox(     
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 200.0,
                    child: const Text("Convertidor de Divisas",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                    ),
                  ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListTile(
                              title: TextField(
                              decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Convertir", 
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: mainColor
                              ) 
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              controller: fromTextController, /*Ejecuta una funcion de tipo callback cada vez que cambia el texto*/
                              keyboardType: const TextInputType.numberWithOptions(decimal: true), /*El teclado se muestra numerico y acepta decimales*/
                                                ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildDropDownButton(fromCurrency), /*Llamamos la funcion con el parametro de fromCurrency que es "DE"(From)* haciendo que el valor predeterminado sea USD*/
                                          FloatingActionButton( onPressed: _doConversion,                                             
                                            child: const Icon(Icons.arrow_downward_sharp),elevation:0.0, backgroundColor: secondColor
                                            ),
                                         _buildDropDownButton(toCurrency), /*Llamamos la funcion con el parametro de fromCurrency que es "A"(To) haciendo que el valor predeterminado sea GBP*/
                                                                         
                                        ]
                                      ),
                                      const SizedBox(height:50.0),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        child: Column(
                                          children:[
                                             ListTile(
                                          title: Chip( /*Genera un rectangulo redondeado de fondo*/
                                          label: result != null ? /*Si resultado es diferente de null ejectua el resultado, sino muestrame un texto en blanco*/
                                          Text(
                                          result,
                                          style: Theme.of(context).textTheme.displaySmall,) : const Text(""),
                                  ),
                                 ),
                                ]
                               )
                              ) 
                            ],
                          ),
                        ),
                      ),       
                    ],
                  ), 
          )
            ),
            ),  
    );
  }


Widget _buildDropDownButton(String currencyCategory) { /*Coge como argumento si el valor de la categoria es DE(From) o A(To)*/  
  return Container(
    padding: const EdgeInsets.symmetric(vertical:4.0,horizontal: 18.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: DropdownButton(
      value: currencyCategory, /*Hace que se dibuje la divisa en el boton*/
      items: currencies.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
        value: value, /*Valor actual de la iteracion*/
        child: Row(
          children: <Widget>[
            Text(value),
          ],  
        ),
      ) ,).toList(), 
      onChanged: (String? value) { /*Le damos al value un valor de String*/
        if(currencyCategory == fromCurrency){
        _onFromChanged(value!);/*Obtiene la divisa presentada en el boton y la muestra*/
        }else {
          _onToChanged(value!);/*Obtiene la divisa presentada en el boton y la muestra*/
        }
       }, 
    ),
  );
}
}


