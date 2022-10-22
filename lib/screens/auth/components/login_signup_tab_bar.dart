import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/auth/components/email_login.dart';
import 'package:kin_music_player_app/screens/auth/components/phone_number_login.dart';

class LoginSignUpTabBar extends StatefulWidget {
  const LoginSignUpTabBar({Key? key}) : super(key: key);

  @override
  State<LoginSignUpTabBar> createState() => _LoginSignUpTabBarState();
}

class _LoginSignUpTabBarState extends State<LoginSignUpTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,

          // Tab Bar
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            indicatorColor: kSecondaryColor,
            unselectedLabelColor: kGrey,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(
                text: 'Login With Email',
              ),
              Tab(
                text: 'Phone number',
              ),
            ],
          ),
        ),

        // Tab View
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const EmailLogin(),
              PhoneNumberLogin(),
            ],
          ),
        ),
      ],
    );
  }
}
