import 'package:flutter/material.dart';

class OnSnapshotError extends StatelessWidget {
  String error;
  OnSnapshotError({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
