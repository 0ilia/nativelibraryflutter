import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'Demo Home Page'),
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
  String _string ="";
  String _startMsg ="";
  String _req;
  String _res = "";
  String _cryptedString = "";
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


Future<void> getResponse() {
    Duration(milliseconds: 300);
    String _algorithm =
        "belt-hash"; // Выбор алгоритма
    _startMsg = textControl.text;
    getCryptoString(_startMsg, _algorithm);

  }


  //Send request to server
 /*
  Future<void> getResponse() async {
    _string = textControl.text;
    _req = "http://10.0.2.2:3001/"+_string;
    print(_startMsg);
    var response = await http.get(_req);
    setState(() {
      _cryptedString = response.body;
    });
  }*/
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
            TextField(
              controller: textControl,
              decoration: InputDecoration(labelText: 'Enter a string'),
            ),
            Text(
              _cryptedString,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getResponse,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
