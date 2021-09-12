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
        return Colors.black;
      else if (i == index)
        return Colors.lightBlue;
      else
        return Colors.grey[300];
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
