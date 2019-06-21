import 'package:flutter/material.dart';
import 'package:poketypes/poketypes.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final List<Poketype> types = Poketype.all;
    final List<String> texts = <String>[''];
    for (Poketype type in types) {
      texts.add(type.label['ja']);
    }
    for (Poketype type in types) {
      texts.add(type.label['ja']);
      for (double w in type.weakness.values) {
        switch (w.toString()) {
          case '0.0':
            texts.add('');
            break;
          case '0.5':
            texts.add('△');
            break;
          case '2.0':
            texts.add('◯');
            break;
          default:
            texts.add('');
        }
      }
    }
    int i = -1;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: GridView.count(
        crossAxisCount: types.length + 1,
        scrollDirection: Axis.horizontal,
        childAspectRatio: 0.4,
        children: texts.map((String text) {
          i++;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: i % (Poketype.all.length + 1) % 2 == 1
                  ? Colors.grey[300]
                  : Colors.transparent,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
