import 'dart:ui';

import 'package:flutter/material.dart' hide TextStyle;
import 'package:poketypes/poketypes.dart';
import 'package:collection/collection.dart';

class Enemy extends StatelessWidget {
  const Enemy({
    Key key,
    this.types,
  }) : super(key: key);

  final List<Poketype> types;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: _MyPainter(types: types),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  _MyPainter({this.types});

  List<Poketype> types;
  double width = 120;
  double height = 120;

  @override
  bool shouldRepaint(_MyPainter oldDelegate) {
    return const ListEquality<Poketype>().equals(oldDelegate.types, types);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(width * -0.5, height * -0.5);

    final Paint thin = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    final Paint bold = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final Paint paint1 = Paint()
      ..color = Color(int.parse('ff' + types[0].color.substring(1), radix: 16));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height * 0.5),
      paint1,
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height * 0.5), thin);

    final ParagraphBuilder paragraphBuilder =
        ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center))
          ..pushStyle(TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))
          ..addText(types[0].label['ja']);
    final Paragraph paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: width));
    canvas.drawParagraph(
        paragraph, Offset(0, height * 0.2 - paragraph.height / 2));

    if (types.length > 1) {
      final Paint paint2 = Paint()
        ..color =
            Color(int.parse('ff' + types[1].color.substring(1), radix: 16));

      canvas.drawRect(
          Rect.fromLTWH(0, height * 0.5, width, height * 0.5), paint2);

      final ParagraphBuilder paragraphBuilder2 =
          ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center))
            ..pushStyle(TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold))
            ..addText(types[1].label['ja']);
      final Paragraph paragraph2 = paragraphBuilder2.build()
        ..layout(ParagraphConstraints(width: width));
      canvas.drawParagraph(
          paragraph2, Offset(0, height * 0.8 - paragraph.height / 2));
    }

    canvas.drawRect(Rect.fromLTWH(0, height * 0.5, width, height * 0.5), thin);

    final Paint white = Paint()..color = Colors.white;
    canvas.drawLine(
        Offset(0.0, height * 0.5), Offset(width, height * 0.5), bold);
    canvas.drawRect(
        Rect.fromLTWH(
            width * 0.375, height * 0.375, width * 0.25, height * 0.25),
        white);
    canvas.drawRect(
        Rect.fromLTWH(
            width * 0.375, height * 0.375, width * 0.25, height * 0.25),
        bold);
  }
}
