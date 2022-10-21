import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/home/home_screen.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/provider/coin_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PaymentView extends StatefulWidget {
  final String url;
  final String userId;
  final String paymentAmount;
  final String paymentMethod;
  final String paymentId;
  final String trackId;
  final String paymentReason;

  const PaymentView(
      {Key? key,
      required this.url,
      required this.userId,
      required this.paymentAmount,
      required this.paymentMethod,
      required this.paymentId,
      required this.trackId,
      required this.paymentReason})
      : super(key: key);
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
//send data to verify the track is bought
  Future sendTrack(payId, String userId, String paymentAmount, trackId) async {
    var body = jsonEncode({
      "userId": userId,
      "payment_id": payId,
      "trackId": trackId,
      "track_price_amount": paymentAmount,
      "isPurcahsed": true
    });

    var url = 'http://104.199.33.9/payment/purchased-tracks/';
    var res = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    if (res.statusCode == 201) {
      Map<String, dynamic> urlbody = json.decode(res.body);

      if (urlbody['isPurcahsed'] == true) {
        return showSucessDialog(
          context,
        );
      } else {
        kShowToast();
        retryFuture(sendTrack, 2000);
      }
    }
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }

  Future savePayment() async {
    var urll = "http://104.199.33.9/payment/save-payment-info/" + pay_id;

    var response = await http.get(Uri.parse("$urll"));

    if (response.statusCode == 200) {
      var resbody = json.decode(response.body);

      var pay_id = resbody['id'];

      sendTrack(pay_id, widget.userId, widget.paymentAmount, widget.trackId);
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
    ),
  );

  late PullToRefreshController pullToRefreshController;

  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    url = widget.url;
    pay_id = widget.paymentId;

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
            urlRequest: URLRequest(
              url: await webViewController?.getUrl(),
            ),
          );
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
    CoinProvider coinProvider = Provider.of<CoinProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pay with Telebir",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest:
                        URLRequest(url: Uri.parse(url.toString())),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onCloseWindow: (contr) {
                      const HomeScreen();
                    },
                    onLoadStart: (controller, url) {
                      setState(() async {
                        final uurl = await webViewController!.getUrl();
                        this.url = widget.url.toString();

                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

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
                          await launch(
                            url,
                          );

                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      setState(() async {
                        final u = url.toString();
                        if (u.contains("result?status=200")) {
                          if (widget.paymentReason == "tip") {
                            print("lookie - payment for tip");
                            try {
                              await coinProvider.buyCoinTeleBirr(
                                paymentAmount: int.parse(widget.paymentAmount),
                                paymentMethod: "telebirr",
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              errorLoggingApiService.logErrorToServer(
                                fileName: fileName,
                                functionName: "onLoadStop",
                                errorInfo: e.toString(),
                              );
                            }
                          } else {
                            await savePayment();
                          }
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
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {},
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
          ],
        ),
      ),
    );
  }
}
