import 'package:flutter_web/material.dart';
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
        title: const Text(''),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final List<Poketype> types = Poketype.all;
    final List<String> texts = <String>[''];
    for (Poketype type in types) {
      texts.add(type.label['ja'].substring(0, 1));
    }
    for (Poketype type in types) {
      texts.add(type.label['ja'].substring(0, 1));
      for (double w in type.weakness.values) {
        if (w == 0) {
          texts.add('✕');
        } else if (w == 0.5) {
          texts.add('△');
        } else if (w == 2.0) {
          texts.add('◯');
        } else {
          texts.add('');
        }
      }
    }
    texts.add('');
    for (Poketype type in types) {
      texts.add(type.label['ja'].substring(0, 1));
    }
    int i = -1;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: GridView.count(
        crossAxisCount: types.length + 1,
        scrollDirection: Axis.horizontal,
        childAspectRatio: 1.0,
        children: texts.map((String text) {
          i++;
          final bool isHeader = i < Poketype.all.length + 1 ||
              i > texts.length - Poketype.all.length - 2 ||
              i % (Poketype.all.length + 1) == 0;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: isHeader
                  ? text == ''
                      ? Colors.grey[200]
                      : Color(int.parse(
                          'ff' +
                              Poketype.all
                                  .firstWhere((Poketype type) =>
                                      type.label['ja'].startsWith(text))
                                  .color
                                  .substring(1),
                          radix: 16))
                  : i % (Poketype.all.length + 1) % 2 == 0
                      ? Colors.grey[200]
                      : Colors.transparent,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isHeader
                      ? Colors.white
                      : text == '◯'
                          ? Colors.green
                          : text == '△' ? Colors.red : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
