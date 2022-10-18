import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/flutter_paypal_sdk.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/payment/paypal/success.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/provider/coin_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../services/provider/music_provider.dart';
import '../../../services/provider/payment_provider.dart';

class PaypalWebview extends StatefulWidget {
  final String paymentReason;
  final String approveUrl;
  final String executeUrl;
  final String accessToken;
  final FlutterPaypalSDK sdk;
  final Function successFunction;
  final double paymentAmount;
  final String paymentMethod;
  final String trackId;
  final String paymentState;
  final Function onPaymentSuccessFunction;
  const PaypalWebview({
    Key? key,
    required this.approveUrl,
    required this.executeUrl,
    required this.accessToken,
    required this.sdk,
    required this.successFunction,
    required this.paymentAmount,
    required this.paymentMethod,
    required this.trackId,
    required this.paymentState,
    required this.paymentReason,
    required this.onPaymentSuccessFunction,
  }) : super(key: key);

  @override
  State<PaypalWebview> createState() => _PaypalWebviewState();
}

class _PaypalWebviewState extends State<PaypalWebview> {
  var paymentProvider;
  void onSuccess() {
    print("onsuccess");
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  int progress = 0;
  @override
  void initState() {
    super.initState();
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    CoinProvider coinProvider = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay With Paypal'),
        backgroundColor: kPrimaryColor,
      ),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            buildProgressBar(context),
            WebView(
              initialUrl: widget.approveUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int _progress) {
                setState(() {
                  progress = _progress;
                });
              },
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) async {
                // Check base on return_url from transaction params;
                if (url.contains('/success')) {
                  final uri = Uri.parse(url);
                  final payerId = uri.queryParameters['PayerID'];
                  if (widget.paymentReason == "trackPurchase") {
                    await paymentProvider.saveUserPaymentAndTrackInfo(
                      paymentAmount: (widget.paymentAmount),
                      paymentMethod: 'PayPal',
                      trackId: widget.trackId.toString(),
                      paymentState: 'COMPLETED',
                      onPaymentCompleteFunction: onSuccess,
                    );
                  }
                  Provider.of<MusicProvider>(context, listen: false)
                      .isPurchaseMade = true;

                  kShowToast(message: "Payment Completed");

                  await widget.sdk.executePayment(
                      widget.executeUrl, payerId!, widget.accessToken);

                  try {
                    CoinProvider coinProvider =
                        Provider.of(context, listen: false);

                    await coinProvider.buyCoin(
                      paymentAmount: widget.paymentAmount.toInt(),
                      paymentMethod: "paypal",
                    );
                    widget.onPaymentSuccessFunction();
                  } catch (e) {
                    ErrorLoggingApiService _errorLoggingApiService =
                        ErrorLoggingApiService();

                    _errorLoggingApiService.logErrorToServer(
                      fileName: "paypalview.dart",
                      functionName: "onPageStarted",
                      errorInfo: e.toString(),
                    );
                  }
                  Navigator.pop(context);

                  // widget.onPaymentSuccessFunction();

                  kShowToast(message: "Payment Completed");
                  kShowToast(message: "Payment Successful!");
                }
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
          ],
        );
      }),
    );
  }

  SafeArea buildProgressBar(
    BuildContext context,
  ) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: 1 - progress / 100,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: progress * width / 100,
            color: Theme.of(context).colorScheme.secondary,
            height: 3.0,
          ),
        ),
      ),
    );
  }
}
