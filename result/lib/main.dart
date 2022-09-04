import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Result test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  final List _spletneStrani = <String>[
    "projekti",
    "o-nas",
    "kariera",
    "blog",
  ];
  List _naslovi = <String>[];
  double _skupniCasIzvajanja = 0.0;
  int _skupnoStKlicev = 0;
  int _stUspesnihKlicev = 0;

  void _fetchSites(int stStrani) async {
    if (stStrani > 4 || stStrani < 1) {
      _showMyDialog();
      return;
    }
    _skupnoStKlicev += stStrani;
    List urls = <Uri>[];
    for (var i = 0; i < 4; i++) {
      urls[i] = Uri.https('www.result.si', _spletneStrani[i]);
    }
    final stopwatch = Stopwatch()..start();
    switch (stStrani) {
      case 1:
        for (var i = 0; i < 4; i++) {
          var url = Uri.https('www.result.si', _spletneStrani[i]);
          var response = await http.get(url);
          if (response.statusCode == 200) {
            _stUspesnihKlicev++;
            print('Number of books about http: ${response.body}.');
          } else {
            print('Request failed with status: ${response.statusCode}.');
          }
        }
        break;
      case 2:
        var results = await Future.wait([
          http.get(urls[0]),
          http.get(urls[1]),
        ]);
        for (var result in results) {
          if (result.statusCode == 200) {
            _stUspesnihKlicev++;
            print('Number of books about http: ${result.body}.');
          } else {
            print('Request failed with status: ${result.statusCode}.');
          }
        }
        results = await Future.wait([
          http.get(urls[2]),
          http.get(urls[3]),
        ]);
        for (var result in results) {
          if (result.statusCode == 200) {
            _stUspesnihKlicev++;
            print('Number of books about http: ${result.body}.');
          } else {
            print('Request failed with status: ${result.statusCode}.');
          }
        }
        break;
      case 3:
        var results = await Future.wait([
          http.get(urls[0]),
          http.get(urls[1]),
          http.get(urls[2]),
        ]);
        for (var result in results) {
          if (result.statusCode == 200) {
            _stUspesnihKlicev++;
            print('Number of books about http: ${result.body}.');
          } else {
            print('Request failed with status: ${result.statusCode}.');
          }
        }
        results = await Future.wait([
          http.get(urls[3]),
        ]);
        for (var result in results) {
          if (result.statusCode == 200) {
            _stUspesnihKlicev++;
            print('Number of books about http: ${result.body}.');
          } else {
            print('Request failed with status: ${result.statusCode}.');
          }
        }
        break;
      case 4:
        var results = await Future.wait([
          http.get(urls[0]),
          http.get(urls[1]),
          http.get(urls[2]),
          http.get(urls[3]),
        ]);
        for (var result in results) {
          if (result.statusCode == 200) {
            _stUspesnihKlicev++;
            print('Number of books about http: ${result.body}.');
          } else {
            print('Request failed with status: ${result.statusCode}.');
          }
        }
        break;
      default:
    }
    setState(() {
      _skupniCasIzvajanja = stopwatch.elapsed as double;
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
            Text("Skupni čas izvajanja: $_skupniCasIzvajanja sekund"),
            Text("Število uspešno izvedeni klicev: $_stUspesnihKlicev"),
            Text(
                "Število neuspešno izvedeni klicev: ${_skupnoStKlicev - _stUspesnihKlicev}"),
            Text("Število vseh klicev: $_skupnoStKlicev"),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: myController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Vnesite število sočasnih klicev od 1 do 4',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (myController.text.isEmpty) {
                  _showMyDialog();
                  return;
                }
                _fetchSites(int.parse(myController.text));
              },
              child: const Text('Poženi'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Naslovi: $_naslovi"),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Napaka'),
          content: const Text('Vnesite številko med 1 in 4.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Vredu'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
