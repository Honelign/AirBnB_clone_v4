import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../screens/home/components/home_search_screen.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      Navigator.pushNamed(context, HomeSearchScreen.routeName);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: const [
            Icon(
              Icons.search,
              color: Colors.black,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Search",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
