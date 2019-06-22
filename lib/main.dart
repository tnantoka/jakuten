import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poketypes/poketypes.dart';

import 'chart.dart';
import 'enemy.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jakuten',
      theme: ThemeData(
        primaryColor: Colors.grey[200],
        buttonTheme: ButtonThemeData(
          minWidth: 70.0,
          height: 48.0,
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
  List<Poketype> _types = <Poketype>[];
  Map<String, double> _weakness = <String, double>{};
  int _maxLife = 0;
  int _currentLife = 0;
  int _maxPower = 0;
  int _currentPower = 0;
  bool _isGameOver = false;
  List<String> _selectedTypes = <String>[];

  final Random _random = Random();

  @override
  void initState() {
    _refreshTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Chart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Chart(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshTypes,
        tooltip: 'Next',
        child: const Icon(Icons.chevron_right),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buildBody() {
    final double life = _currentLife / _maxLife;
    return Column(
      children: <Widget>[
        SizedBox(
          child: LinearProgressIndicator(
            value: life,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(life > 0.5
                ? Colors.green
                : life > 0.2 ? Colors.orange : Colors.red),
          ),
          height: 8.0,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 0),
          child: Text(
            'HP: $_currentLife / $_maxLife',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Enemy(
            types: _types,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          child: Text(
            // _isGameOver ? _currentLife < 1 ? 'You Win!' : 'You Lose...' : '',
            _isGameOver ? _currentLife < 1 ? 'やったね！' : 'ざんねん…' : '　',
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: _currentLife < 1 ? Colors.green : Colors.red,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: Poketype.all.map((Poketype type) {
              return _isGameOver || _selectedTypes.contains(type.name)
                  ? OutlineButton(
                      child: Text(
                        '${type.label['ja'].substring(0, 1)}\n(${_weakness[type.name]})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      textColor: Colors.white,
                      onPressed: null,
                      disabledBorderColor: _weakness[type.name] >= 4.0
                          ? Colors.cyan
                          : _weakness[type.name] >= 2.0
                              ? Colors.green
                              : _weakness[type.name] >= 1.0
                                  ? Colors.grey
                                  : _weakness[type.name] >= 0.5
                                      ? Colors.red
                                      : Colors.black,
                      borderSide: BorderSide(width: 3.0),
                    )
                  : FlatButton(
                      child: Text(
                        type.label['ja'].substring(0, 1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      color: Color(
                          int.parse('ff' + type.color.substring(1), radix: 16)),
                      textColor: Colors.white,
                      onPressed: () {
                        if (_currentPower < 1) {
                          return;
                        }
                        setState(() {
                          _selectedTypes.add(type.name);
                          _currentLife -= (10 * _weakness[type.name]).toInt();
                          _currentPower -= 1;
                          if (_currentPower < 1) {
                            _isGameOver = true;
                          }
                        });
                      },
                    );
            }).toList(),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
          child: Text(
            'PP: $_currentPower / $_maxPower',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }

  void _refreshTypes() {
    final List<Poketype> allTypes = Poketype.all.toList();
    final List<Poketype> types = <Poketype>[];
    final int num = _random.nextInt(2) + 1;
    for (int i = 0; i < num; i++) {
      final int index = _random.nextInt(allTypes.length - 1);
      types.add(allTypes[index]);
      allTypes.removeAt(index);
    }

    Map<String, double> weakness;
    if (num > 1) {
      weakness = types[0].weakness.map((String key, double value) {
        return MapEntry<String, double>(key, value * types[1].weakness[key]);
      });
    } else {
      weakness = types[0].weakness;
    }

    int life = 0;
    int power = 0;
    weakness.forEach((String key, double value) {
      if (value >= 2.0) {
        life += (10 * value).toInt();
        power += 1;
      }
    });

    setState(() {
      _types = types;
      _maxLife = life;
      _currentLife = life;
      _maxPower = power;
      _currentPower = power;
      _isGameOver = false;
      _selectedTypes = <String>[];
      _weakness = weakness;
    });
  }
}
