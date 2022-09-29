import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';

import 'size_config.dart';

//a-0xFFF67E7D  b-0xFFabdf75  c-0xFF009ddc
// const kPrimaryColor = Color(0xFF464646);
// const kArtistID = "gZkd8CJAxESJpJFmXRLnU0IFkhE3";
const kArtistID = "";

// Navy Primary
// const kPrimaryColor = Color(0XFF0A192F);
const kPrimaryColor = Colors.black;

// Yellow Secondary
const kSecondaryColor = Color(0xFF3D8361);
// const kSecondaryColor = Color(0XFFFCE762);
const kLightSecondaryColor = Color(0xFF009ddc);
const kTertiaryColor = Color(0xFF7e9632);
const kGrey = Color(0xFFBBBBBB);
const kTextColor = Color(0xFF757575);

// Text Colors
const kDarkTextColor = Color(0XFFFFFF00);
const kLightTextColor = Color(0XFFFFFFFF);

// number of seconds to play before adding to recently played
const int recentlyPlayedWaitDuration = 5;

// number of seconds to play before counting to popular
const int popularCountWaitDuration = 5;

// number of seconds to play before ending preview
const int previewWaitDuration = 45;

const String apiUrl = 'https://kinmusic.gamdsolutions.com';

// service urls
const String kinAssetBaseUrl =
    'https://storage.googleapis.com/kin-project-352614-kinmusic-storage';

const String kinAssetsBaseUrlOld =
    "https://storage.googleapis.com/kin-project-352614-storage";

const String kinNewAsset =
    "https://storage.googleapis.com/kin-project-352614-kinmusic-storage";
const String kinMusicBaseUrl = 'https://music-service-vdzflryflq-ew.a.run.app';

const String kinRadioBaseUrl = 'https://radioservice.kinideas.com';
const String kinPodcastBaseUrl = 'https://podcastservice.kinideas.com';
const String kinSearchBaseUrl = 'https://searchservice.kinideas.com';
const String kAnalyticsBaseUrl =
    "https://analytics-service-v1-vdzflryflq-ew.a.run.app";
const String kinPaymentUrl = "http://104.199.33.9/";
const String kinProfileBaseUrl =
    "https://kinideas-profile-v1-vdzflryflq-ew.a.run.app";
const String KinRadioUrl =
    "https://radio-service-vdzflryflq-ew.a.run.app/mobileApp/";
//
const kAnimationDuration = Duration(milliseconds: 200);
const String youtubeDataApiKey = "AIzaSyAzB1wCAyyNEUOY87xJYWbMMwaWeUhl-ms";
List<String> allowedCoinValues = [
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

const List<PopupMenuItem> kMusicPopupMenuItem = [
  PopupMenuItem(child: Text('Add to playlist'), value: 1),
  PopupMenuItem(child: Text('Detail'), value: 2),
];
const List<PopupMenuItem> kPlaylistPopupMenuItem = [
  PopupMenuItem(child: Text('Remove from playlist'), value: 1),
  PopupMenuItem(child: Text('Detail'), value: 2),
];
const List<PopupMenuItem> kPodcastPopupMenuItem = [
  PopupMenuItem(child: Text('Detail'), value: 1),
];
const List<PopupMenuItem> kDeletePlaylistTitle = [
  PopupMenuItem(child: Text('Remove playlist'), value: 1),
];
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
const String kConnectionErrorMessage =
    "Something went wrong. Please refresh the page.";

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
