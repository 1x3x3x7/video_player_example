import 'package:flutter/material.dart';

class SessionProgressWidget extends StatelessWidget {
  final int index;
  final int size;
  const SessionProgressWidget(
      {Key? key, required this.index, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fonySize = MediaQuery.of(context).size.width / size;
    final color = (i, index) {
      if (i < index)
        return Theme.of(context).hintColor;
      else if (i == index)
        return Theme.of(context).primaryColor;
      else
        return Theme.of(context).focusColor;
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < size; i++)
          Text(
            '■',
            style: TextStyle(color: color(i, index), fontSize: fonySize),
          )
      ],
    );
  }
}
