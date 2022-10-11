import 'package:flutter/widgets.dart';
import 'package:kin_music_player_app/main.dart';

import 'package:kin_music_player_app/screens/library/favorite/favorite.dart';
import 'package:kin_music_player_app/screens/home/components/home_search_screen.dart';
import 'package:kin_music_player_app/screens/login_signup/components/forget_password.dart';
import 'package:kin_music_player_app/screens/login_signup/components/otp_verification.dart';
import 'package:kin_music_player_app/screens/login_signup/login_signup_body.dart';
import 'package:kin_music_player_app/screens/podcast/component/all_category.dart';
import 'package:kin_music_player_app/screens/podcast/component/all_podcasts.dart';
import 'package:kin_music_player_app/screens/podcast/component/podcast_search_screen.dart';
import 'package:kin_music_player_app/services/network/regi_page.dart';

import 'screens/home/home_screen.dart';
import 'components/custom_bottom_app_bar.dart';

class AppRouter {
  final Map<String, WidgetBuilder> allRoutes = {
    LandingPage.routeName: (context) => const LandingPage(),
    HomeScreen.routeName: (context) => const HomeScreen(),
    HomeSearchScreen.routeName: (context) => const HomeSearchScreen(),
    CustomBottomAppBar.routeName: (context) => const CustomBottomAppBar(),
    AllCategory.routeName: (context) => const AllCategory(),
    Favorite.routeName: (context) => const Favorite(),
    AllPodCastList.routeName: (context) => const AllPodCastList(),
    LoginSignUpBody.routeName: (context) => const LoginSignUpBody(),
    ForgetPassword.routeName: (context) => ForgetPassword(),
    RegPage.routeName: (context) => RegPage(),
    OTPVerification.routeName: (context) => OTPVerification(),
    PodcastSearchScreen.routeName: (context) => const PodcastSearchScreen(),
  };
}
