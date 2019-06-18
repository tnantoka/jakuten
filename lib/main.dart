import 'package:flutter/material.dart';
import 'package:poketypes/poketypes.dart';

import 'enemy.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jakuten',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(
          minWidth: 44.0,
        ),
      ),
      home: MyHomePage(title: 'Jakuten'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          const LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'HP: 14/20',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Enemy(
              types: <Poketype>[Poketype('normal'), Poketype('fire')],
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: Poketype.all.map((Poketype type) {
              return FlatButton(
                child: Text(type.label['ja'].substring(0, 1)),
                color:
                    Color(int.parse('ff' + type.color.substring(1), radix: 16)),
                textColor: Colors.white,
                onPressed: () {},
              );
            }).toList(),
          ),
          const SizedBox(
            height: 16.0,
          )
        ],
      ),
    );
  }
}
