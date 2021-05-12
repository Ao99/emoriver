import 'package:flutter/cupertino.dart';

class RowOrColumn extends StatelessWidget {
  const RowOrColumn({Key key, this.isRow, this.children}) : super(key: key);
  final bool isRow;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return isRow
        ? Row(children: children)
        : Column(children: children);
  }
}