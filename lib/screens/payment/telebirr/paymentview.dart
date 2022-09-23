import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PaymentView extends StatefulWidget {
  final String url;
  final String userId;
  final String payment_amount;
  final String payment_method;
  final payment_id;
  final track_id;

  const PaymentView({
    Key? key,
    required this.url,
    required this.userId,
    required this.payment_amount,
    required this.payment_method,
    required this.payment_id,
    required this.track_id,
  }) : super(key: key);
  @override
  _PaymentViewState createState() => new _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
//send data to verify the track is bought
  Future sendTrack(
      pay_id, String userId, String payment_amount, track_id) async {
    /*  var payment_body = {
      'payment_id': pay_id,
      'user_id': userId,
      'amount': payment_amount
    }; */
    var body = jsonEncode({
      "userId": userId,
      "payment_id": pay_id,
      "trackId": track_id,
      "track_price_amount": payment_amount,
      "isPurcahsed": true
    });
    debugPrint("body" + body.toString());
    var url = 'http://104.199.33.9/payment/purchased-tracks/';
    var res = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    debugPrint(res.statusCode.toString());
    if (res.statusCode == 201) {
      debugPrint("successful");
      Map<String, dynamic> urlbody = json.decode(res.body);
      debugPrint("ispurchased" + urlbody['ispurchased'].toString());
      debugPrint(urlbody.toString());
      if (urlbody['isPurcahsed'] == true) {
        return showSucessDialog(
          context,
        );
      } else {
        kShowToast();
        retryFuture(sendTrack, 2000);
      }

      debugPrint("urlBody" + urlbody['id'].toString());
    }
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

  Future savePayment() async {
    var urll = "http://104.199.33.9/payment/save-payment-info/" + pay_id;
    /* var body = json.encode({
      "userId": widget.userId,
      "payment_amount": widget.payment_amount,
      "payment_method": widget.payment_method,
      "payment_state": "completed"
    }); */
    var response = await http.get(Uri.parse("$urll"));
    debugPrint("url=" + urll.toString());
    debugPrint(response.toString());
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      var resbody = json.decode(response.body);
      debugPrint("boddy" + resbody.toString());
      var pay_id = resbody['id'];
      debugPrint("payyy" + pay_id.toString());
      sendTrack(pay_id, widget.userId, widget.payment_amount, widget.track_id);
    }
  }

  final GlobalKey webViewKey = GlobalKey();
  late final url;
  late final pay_id;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        safeBrowsingEnabled: false,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;

  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    url = widget.url;
    pay_id = widget.payment_id;

    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: kPrimaryColor,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pay with Telebir",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
            child: Column(children: [
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: Uri.parse(url.toString())),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onCloseWindow: (contr) {
                    HomeScreen();
                  },
                  onLoadStart: (controller, url) {
                    setState(() async {
                      final uurl = await webViewController!.getUrl();
                      this.url = widget.url.toString();

                      urlController.text = this.url;
                      print("urrrl" + url.toString());
                      print("urrrl" + uurl.toString());
                      //  debugPrint("urlll" + url.toString());
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;
                    // debugPrint("urii" + uri.toString());

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() async {
                      print("whaattt" + url.toString());
                      print("pppath" + url!.path.toString());
                      final u = url.toString();
                      if (u.contains("result?status=200")) {
                        debugPrint("asddd" + pay_id.toString());
                        savePayment();

                        // Navigator.pop(context);
                        // await kShowToast(message: "Payment Successful!");
                      }

                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    const Text("pull the screen to refresh");

                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                      // print("come on" + controller.getUrl().toString());
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? SpinKitCircle(
                        color: Colors.blueGrey[800],

                        // value: progress
                      )
                    : Container(),
              ],
            ),
          )
        ])));
  }
}
