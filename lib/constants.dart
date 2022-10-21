import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';

import 'size_config.dart';

//a-0xFFF67E7D  b-0xFFabdf75  c-0xFF009ddc
// const kPrimaryColor = Color(0xFF464646);
// const kArtistID = "gZkd8CJAxESJpJFmXRLnU0IFkhE3";
const kArtistID = "";

// colors
const kPrimaryColor = Colors.black;
const kSecondaryColor = Color(0xFF052C54);
const kLightSecondaryColor = Color(0xFF009ddc);
const kTertiaryColor = Color(0xFF7e9632);
const kGrey = Color(0xFFBBBBBB);
const kTextColor = Color(0xFF757575);
const kDarkTextColor = Color(0XFFFFFF00);
const kLightTextColor = Color(0XFFFFFFFF);
const kPopupMenuBackgroundColor = Color.fromARGB(255, 43, 42, 42);
const kPopupMenuForegroundColor = kGrey;

// refresh
const refreshIndicatorBackgroundColor = kSecondaryColor;
const refreshIndicatorForegroundColor = Colors.white;

// number of seconds to play before adding to recently played
const int recentlyPlayedWaitDuration = 5;

// number of seconds to play before counting to popular
const int popularCountWaitDuration = 5;

// number of seconds to play before ending preview
const int previewWaitDuration = 45;

const String apiUrl = 'https://kinmusic.gamdsolutions.com';

// asset urls
const String kinAssetBaseUrl =
    'https://storage.googleapis.com/kin-project-352614-kinmusic-storage';

const String kinAssetsBaseUrlOld =
    "https://storage.googleapis.com/kin-project-352614-storage";

// service urls
const String kinMusicBaseUrl = 'https://music-service-vdzflryflq-ew.a.run.app';

const String kinRadioBaseUrl = 'https://radioservice.kinideas.com';
const String kinPodcastBaseUrl =
    'https://podcast-service-dev-vdzflryflq-ew.a.run.app';
const String kinSearchBaseUrl = 'https://searchservice.kinideas.com';
const String kAnalyticsBaseUrl =
    "https://analytics-service-vdzflryflq-ew.a.run.app";
const String kinPaymentUrl = "http://104.199.33.9";
const String kinProfileBaseUrl =
    "https://kinideas-profile-vdzflryflq-ew.a.run.app";
const String KinRadioUrl =
    "https://radio-service-vdzflryflq-ew.a.run.app/mobileApp/";
//
const kAnimationDuration = Duration(milliseconds: 200);
const String youtubeDataApiKey = "AIzaSyAzB1wCAyyNEUOY87xJYWbMMwaWeUhl-ms";
List<String> allowedCoinValues = [
  "1",
  "5",
  "10",
  "15",
  "25",
  "50",
  "100",
  "500",
  "1000",
  "1500"
];

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

kShowToast({String message = "Please Check Your Connection"}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

kShowPrice({String message = "Track price 0 can not be paid"}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

kTelebirrToast({String message = "TeleBirr server not responding"}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

kShowRetry({String message = "retrying... check your internet connection"}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

showSucessDialog(
  context,
) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.success,
    body: const Center(
      child: Text(
        "Payment successful",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    ),
    title: 'title',
    desc: 'desc',
    btnOkOnPress: () {
      Navigator.pop(context);
    },
  )..show();
}

checkConnection(status) {
  if (status == ConnectivityStatus.wifi ||
      status == ConnectivityStatus.cellular) {
    return true;
  }
  return false;
}

// POPUP MENU ITEMS
const TextStyle popupTextStyle = TextStyle(color: kPrimaryColor);

const List<PopupMenuItem> kMusicPopupMenuItem = [
  PopupMenuItem(
    child: Text(
      'Add to playlist',
      style: popupTextStyle,
    ),
    value: 1,
  ),
  PopupMenuItem(
    child: Text(
      'Detail',
      style: popupTextStyle,
    ),
    value: 2,
  ),
  PopupMenuItem(
    child: Text(
      'Download',
      style: popupTextStyle,
    ),
    value: 3,
  ),
];
// For Music Card
const List<PopupMenuItem> kMusicOfflinePopupMenuItem = [
  PopupMenuItem(
    child: Text(
      'Add to playlist',
      style: popupTextStyle,
    ),
    value: 1,
  ),
  PopupMenuItem(
    child: Text(
      'Detail',
      style: popupTextStyle,
    ),
    value: 2,
  ),
  PopupMenuItem(
    child: Text(
      'Remove',
      style: popupTextStyle,
    ),
    value: 3,
  ),
];
const List<PopupMenuItem> kPlaylistPopupMenuItem = [
  PopupMenuItem(
    child: Text(
      'Remove from playlist',
      style: popupTextStyle,
    ),
    value: 1,
  ),
  PopupMenuItem(
    child: Text(
      'Detail',
      style: popupTextStyle,
    ),
    value: 2,
  ),
  PopupMenuItem(
    child: Text(
      'Download',
      style: popupTextStyle,
    ),
    value: 3,
  ),
];
const List<PopupMenuItem> kPodcastPopupMenuItem = [
  PopupMenuItem(
    child: Text(
      'Detail',
      style: popupTextStyle,
    ),
    value: 1,
  ),
];
const List<PopupMenuItem> kDeletePlaylistTitle = [
  PopupMenuItem(
    child: Text(
      'Remove playlist',
      style: popupTextStyle,
    ),
    value: 1,
  ),
];
const List<PopupMenuItem> kPlaylistTitleCardsPopupMenuItems = [
  PopupMenuItem(
    child: Text(
      'Delete Playlist',
      style: popupTextStyle,
    ),
    value: 1,
  ),
  // PopupMenuItem(child: Text('Playlist Detail'), value: 1),
];

//
const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kConnectionErrorMessage = "No Connection.";
const String kReconnectErrorMessage = "Connect to Cellular data or Wifi";
const String kPrivacyPolicy =
    "We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the &ldquo;Last updated&rdquo; date of this Privacy Policy. You are encouraged to periodically review this Privacy Policy to stay informed of updates. You will be deemed to have been made aware of, will be subject to, and will be deemed to have accepted the changes in any revised Privacy Policy by your continued use of the Application after the date such revised Privacy Policy is posted.";
const String kTermsOfService =
    " We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the &ldquo;Last updated&rdquo; date of this Privacy Policy. You are encouraged to periodically review this Privacy Policy to stay informed of updates. You will be deemed to have been made aware of, will be subject to, and will be deemed to have accepted the changes in any revised Privacy Policy by your continued use of the Application after the date such revised Privacy Policy is posted.";

const String kHelpAndSupport =
    "We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the &ldquo;Last updated&rdquo; date of this Privacy Policy. You are encouraged to periodically review this Privacy Policy to stay informed of updates. You will be deemed to have been made aware of, will be subject to, and will be deemed to have accepted the changes in any revised Privacy Policy by your continued use of the Application after the date such revised Privacy Policy is posted";

const String lackingCoinsMessage = "You do not have enough balance. Buy coins.";

const String kProfileLoadingError = "Could not load profile";
final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

const possibleAnalyticTypes = [
  'Daily',
  'Weekly',
  'Monthly',
];

const possibleUploadTypesCompany = [
  "Producers",
  "Artists",
  'Albums',
  'Tracks',
];

const possibleUploadTypesProducer = [
  "Artists",
  'Albums',
  'Tracks',
];

const possibleUploadTypesArtist = [
  'Albums',
  'Tracks',
];

TextStyle headerTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white.withOpacity(0.9),
);

TextStyle noDataDisplayStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white.withOpacity(0.9),
);

// new styles
TextStyle headerOneTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 24,
  letterSpacing: 0.5,
  fontWeight: FontWeight.w700,
);

TextStyle headerTwoTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 22,
  letterSpacing: 0,
  fontWeight: FontWeight.w600,
);

TextStyle headerThreeTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 22,
  letterSpacing: 0.0,
  fontWeight: FontWeight.w600,
);

BoxDecoration linearGradientDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xFF052C54),
      const Color(0xFFD9D9D9).withOpacity(0.7),
    ],
  ),
);

double minPlayerHeight = 70;
