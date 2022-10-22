import 'package:flutter/widgets.dart';
import 'package:kin_music_player_app/main.dart';
import 'package:kin_music_player_app/screens/library/favorite/favorite.dart';
import 'package:kin_music_player_app/screens/home/components/home_search_screen.dart';
import 'package:kin_music_player_app/screens/auth/components/otp_verification.dart';
import 'package:kin_music_player_app/screens/auth/login_signup_body.dart';
import 'package:kin_music_player_app/screens/auth/register_page.dart';
import 'screens/home/home_screen.dart';
import 'components/custom_bottom_app_bar.dart';

class AppRouter {
  final Map<String, WidgetBuilder> allRoutes = {
    LandingPage.routeName: (context) => const LandingPage(),
    HomeScreen.routeName: (context) => const HomeScreen(),
    HomeSearchScreen.routeName: (context) => const HomeSearchScreen(),
    CustomBottomAppBar.routeName: (context) => const CustomBottomAppBar(),
    Favorite.routeName: (context) => const Favorite(),
    LoginSignUpBody.routeName: (context) => const LoginSignUpBody(),
    RegisterPage.routeName: (context) => RegisterPage(),
    OTPVerification.routeName: (context) => OTPVerification(),
  };
}
