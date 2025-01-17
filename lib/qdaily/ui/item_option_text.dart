import 'package:flutter/material.dart';
import 'package:flutter_app/utils/utils.dart';
import '../../bean/qdaily_app.dart';
import 'view_option_author.dart';
import 'view_option_bottom.dart';

class ItemOptionText extends StatelessWidget {
  final Option option;

  ItemOptionText({Key key, @required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Utils.randomColor(),
        padding: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          ViewOptionAuthor(
              avatar: '${option?.author?.avatar}',
              name: '${option?.author?.name}'),
          ConstrainedBox(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('${option.content}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: option.content.length > 8 ? 14 : 18)),
                  alignment: Alignment.center),
              constraints: BoxConstraints(minHeight: 80)),
          ViewOptionBottom(praiseCount: option.praiseCount)
        ]));
  }
}
