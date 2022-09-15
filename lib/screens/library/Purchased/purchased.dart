import 'package:flutter/material.dart';

class Purchased extends StatefulWidget {
  const Purchased({Key? key}) : super(key: key);

  @override
  State<Purchased> createState() => _PurchasedState();
}

class _PurchasedState extends State<Purchased> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Purchased screen coming soon',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
