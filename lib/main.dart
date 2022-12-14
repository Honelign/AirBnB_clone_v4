import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/firebase_options.dart';
import 'package:kin_music_player_app/routes.dart';
import 'package:kin_music_player_app/screens/auth/login_signup_body.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/connectivity_service.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:kin_music_player_app/services/provider/analytics_provider.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:kin_music_player_app/services/provider/cached_favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/coin_provider.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/genre_provider.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/services/provider/multi_select_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:kin_music_player_app/services/provider/payment_provider.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/services/provider/recently_played_provider.dart';
import 'package:kin_music_player_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // secret stripe key =sk_test_51LcOtyFvUcclFpL2Isr4xf7kyt67mCFY6LHxNy5mu06kfk5MzcZRU11W6dU211P4XGyMPoYTltDWBrftA3OoFhHz00pPkHiT4s
  Stripe.publishableKey =
      "pk_test_51LcOtyFvUcclFpL2uAwDrXq1HbZHXIDRywFiLWWLl32E3OyOjfSkraaNwAsHzAYmnfSGoGlK3QyQ9b6PqiXGWVvx001D1KIQCz";
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     systemNavigationBarColor: kPrimaryColor,
  //     statusBarColor: kSecondaryColor,
  //     systemNavigationBarIconBrightness: Brightness.light,
  //   ),
  // );

  runApp(
    MultiProvider(
      child: const Kin(),
      providers: [
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => CoinProvider()),
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
        ChangeNotifierProvider(create: (_) => ArtistProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => MusicPlayer()),
        ChangeNotifierProvider(create: (_) => PodcastPlayer()),
        ChangeNotifierProvider(create: (_) => FavoriteMusicProvider()),
        ChangeNotifierProvider(create: (_) => PlayListProvider()),
        ChangeNotifierProvider(create: (_) => GenreProvider()),
        ChangeNotifierProvider(create: (_) => RadioProvider()),
        ChangeNotifierProvider(create: (_) => RecentlyPlayedProvider()),
        ChangeNotifierProvider(create: (_) => CachedFavoriteProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => MultiSelectProvider()),
        ChangeNotifierProvider(create: (_) => OfflineMusicProvider()),
        ChangeNotifierProvider(create: (_) => PodcastProvider()),
        StreamProvider(
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          initialData: ConnectivityStatus.offline,
        ),
      ],
    ),
  );
}

class Kin extends StatefulWidget {
  const Kin({Key? key}) : super(key: key);

  @override
  State<Kin> createState() => _KinState();
}

class _KinState extends State<Kin> {
  @override
  void initState() {
    super.initState();

    Provider.of<CachedFavoriteProvider>(
      context,
      listen: false,
    ).cacheFavorite();
  }

  @override
  void dispose() {
    // SingletonPlayer.instance.stop();
    super.dispose();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: kPrimaryColor,
        statusBarColor: kSecondaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    final AppRouter _appRouter = AppRouter();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kin Music',
      theme: theme(),
      initialRoute: "/",
      routes: _appRouter.allRoutes,
    );
  }
}

Future<bool> checkIfAuthenticated() async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString('id') != null ||
        FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> checkIfEmailIsVerified() async {
  var user = FirebaseAuth.instance.currentUser;

  try {
    if (user == null) {
      return false;
    } else {
      return FirebaseAuth.instance.currentUser!.emailVerified;
    }
  } catch (e) {
    return false;
  }
}

class LandingPage extends StatefulWidget {
  static String routeName = "/";

  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb == true) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No web support yet!",
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
    }
    return FutureBuilder(
      future: checkIfAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: linearGradientDecoration,
            child: const KinProgressIndicator(),
          );
        } else {
          if (snapshot.hasData && !snapshot.hasError && snapshot.data == true) {
            return FutureBuilder(
              future: checkIfEmailIsVerified(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: const KinProgressIndicator(),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: linearGradientDecoration,
                  );
                } else {
                  return const CustomBottomAppBar();
                }
              }),
            );
          } else {
            return const LoginSignUpBody();
          }
        }
      },
    );
  }
}
