import 'dart:async';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class SearchBar extends StatelessWidget {
  final String hint;
  const SearchBar({Key? key, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        onChanged: (val) {},
        style: const TextStyle(color: kGrey),
        cursorColor: kGrey,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: kGrey),
            prefixIcon: const Icon(
              Icons.search,
              color: kGrey,
            )),
      ),
    );
  }
}

class DeBouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  DeBouncer({required this.milliseconds});

  run(VoidCallback action) async {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
