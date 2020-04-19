import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Ilya Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _startMsg = "";
  String _string ="";
  String _endMsg = "";
  String _req="";
  String _res = "";
  String _cryptedString ="";
  final textControl = TextEditingController();

  static const platform = const MethodChannel('channel.ilya.crypto');

  Future<void> getCryptoString(String text, String algorithm) async {
    // Duration(milliseconds: 300);
    String result;
    result = await platform
        .invokeMethod('cryptString', {"text": text, "algorithm": algorithm});
    setState(() {
      _cryptedString = result;
    });
  }

  // ignore: missing_return
  Future<void> getResponse() {
    Duration(milliseconds: 300);
    String _algorithm =
        "belt-hash"; // Выбор алгоритма
    _startMsg = textControl.text;
    getCryptoString(_startMsg, _algorithm);

  }

  Future<void> getHashString() async {
    _string = textControl.text;
    _req = "https://10.0.2.2:3000";
    var response = await http.get(_req);
    setState(() {
      _res = response.body;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _req,
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              onPressed: getHashString,
              child: const Text(
                  'Отправиь запрос на сервер',
                  style: TextStyle(fontSize: 20)
              ),
            ),
            TextField(
              controller: textControl,
              decoration: InputDecoration(labelText: 'Enter a string'),
            ),
            RaisedButton(
                onPressed: getResponse,
              child: const Text(
                  'Зашифровать нативной библиотекой',
                  style: TextStyle(fontSize: 20)
              ),
            ),
            Text(
              _cryptedString,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),

    );
  }
}
