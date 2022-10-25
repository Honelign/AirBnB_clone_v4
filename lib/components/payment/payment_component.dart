import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_paypal_sdk/flutter_paypal_sdk.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/payment/paypal/paypalview.dart';
import 'package:http/http.dart' as http;
import 'package:kin_music_player_app/screens/payment/telebirr/paymentview.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/payment_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PaymentComponent extends StatefulWidget {
  String paymentPrice;
  int trackId;
  String paymentReason;
  Function onSuccessFunction;
  PaymentComponent({
    Key? key,
    required this.paymentPrice,
    required this.trackId,
    required this.paymentReason,
    required this.onSuccessFunction,
  }) : super(key: key);

  @override
  State<PaymentComponent> createState() => _PaymentComponentState();
}

class _PaymentComponentState extends State<PaymentComponent> {
  final String className = "_PaymentComponentState";
  final String fileName = "payment_component.dart";

  final ErrorLoggingApiService _errorLoggingApiService =
      ErrorLoggingApiService();

  //
  late PaymentProvider paymentProvider;
//getting user id from shared preference
  late String id;
  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getString('id').toString();
  }

  //get telebirr url
  Future getUrl() async {
    var linkMap;
    var link;
    var paymentData;
    var paymentId;
    var body = json.encode({
      'userId': id,
      'payment_amount': widget.paymentPrice,
      'payment_method': "telebirr",
      "payment_state": "PENDING"
    });

    var res = await http.post(
        Uri.parse("$kinPaymentUrl/payment/purchase-with-telebirr/"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: body);

    if (res.statusCode == 200) {
      Map<String, dynamic> response = json.decode(res.body);

      for (var key in response.keys) {
        linkMap = response['pay'];
        paymentData = response['data'];

        link = linkMap['data'];
        paymentId = paymentData['id'];
      }
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PaymentView(
              onSucess: widget.onSuccessFunction,
              isCoin: false,
              userId: id,
              paymentAmount: widget.paymentPrice,
              paymentMethod: "telebirr",
              url: link['toPayUrl'].toString(),
              paymentId: paymentId.toString(),
              trackId: widget.trackId.toString(),
            );
          },
        ),
      );
    }
  }

  //payment methods for paypal
  payWithPayPal() async {
    FlutterPaypalSDK sdk = FlutterPaypalSDK(
      clientId:
          'AQ0XWp625sJxSs6EJADNsK2iHLSbS99w5lkybY72euU_zbmBvT-7QF_XMvqVaE5xs9aOUQ4AXmDgYsCl',
      clientSecret:
          'EIeP-k7aoAkqc170_vUkN094sP6aIv3v5KSnfdNpDm8rgbsx1H_bFAdohSs3lmSmDM7t_6hY2UzkMIKW',
      mode: Mode.sandbox, // this will use sandbox environment
    );
    AccessToken accessToken = await sdk.getAccessToken();
    if (accessToken.token != null) {
      Payment payment = await sdk.createPayment(
        transaction(),
        accessToken.token!,
      );
      if (payment.status) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaypalWebview(
              isCoin: false,
              onPaymentSuccessFunction: widget.onSuccessFunction,
              paymentAmount: double.parse(widget.paymentPrice),
              paymentMethod: 'Paypal',
              trackId: widget.trackId.toString(),
              paymentState: 'COMPLETED',
              approveUrl: payment.approvalUrl!,
              executeUrl: payment.executeUrl!,
              accessToken: accessToken.token!,
              sdk: sdk,
              successFunction: () {},
            ),
          ),
        );
      }
    }
  }

  transaction() {
    Map<String, dynamic> transactions = {
      "intent": "sale",
      "payer": {
        "payment_method": "paypal",
      },
      "redirect_urls": {
        "return_url": "/success",
        "cancel_url": "/cancel",
      },
      'transactions': [
        {
          "amount": {
            "currency": "USD",
            "total": widget.paymentPrice,
          },
        }
      ],
    };

    return transactions;
  }

  //payment methods for stripe
  String SECRET_KEY =
      'sk_test_51LcOtyFvUcclFpL2Isr4xf7kyt67mCFY6LHxNy5mu06kfk5MzcZRU11W6dU211P4XGyMPoYTltDWBrftA3OoFhHz00pPkHiT4s';

  Map<String, dynamic>? paymentIntent;
  bool isLoading = false;
  Future<void> payWithStripe(context) async {
    try {
      paymentIntent = await createPaymentIntent(widget.paymentPrice, 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                style: ThemeMode.dark,
                merchantDisplayName: 'kinideas'),
          )
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "payWithStripe",
        errorInfo: e.toString(),
        remark: s.toString(),
      );
    }
  }

  // STRIPE SUCCESS
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        if (widget.paymentReason == "trackPurchase") {
          await paymentProvider.saveUserPaymentAndTrackInfo(
            paymentAmount: double.parse(widget.paymentPrice),
            paymentMethod: 'stripe',
            trackId: widget.trackId.toString(),
            paymentState: 'COMPLETED',
            onPaymentCompleteFunction: widget.onSuccessFunction,
          );
        }
        Provider.of<MusicProvider>(context, listen: false).isPurchaseMade =
            true;

        widget.onSuccessFunction;
        // showSucessDialog(context);
        // kShowToast(message: "Payment Completed");

        paymentIntent = null;
      }).onError((error, stackTrace) {
        kShowToast(message: "Could not complete payment");
        _errorLoggingApiService.logErrorToServer(
          fileName: fileName,
          functionName: "displayPaymentSheet",
          errorInfo: error.toString(),
          className: className,
        );
      });
    } on StripeException catch (e) {
      kShowToast(message: "Could not complete payment");

      _errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "displayPaymentSheet",
        errorInfo: e.toString(),
        className: className,
      );
    } catch (e) {
      kShowToast(message: "Could not complete payment");
      _errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "displayPaymentSheet",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "createPaymentIntent",
        errorInfo: err.toString(),
      );
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  @override
  void initState() {
    getUserId();
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov =
        Provider.of<PaymentProvider>(context, listen: false).isBought(context);
    return Container(
      height: getProportionateScreenHeight(450) +
          MediaQuery.of(context).viewInsets.bottom,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kGrey.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(50),
              right: getProportionateScreenWidth(50),
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: isLoading == true
                ? const Center(
                    child: KinProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 4.0,
                          bottom: 30,
                        ),
                        child: Text(
                          "Pay With",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // pay with telebirr
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          getUrl();

                          // navigate to tele birr pay view
                          /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PaymentView();
                              },
                            ),
                          ); */

                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            // Make rounded corners
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                  2.0,
                                ),
                                child: Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        20,
                                      ),
                                      bottomLeft: Radius.circular(
                                        20,
                                      ),
                                    ), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                        48,
                                      ),
                                      child: Image.asset(
                                        'assets/images/2.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // spacer
                              const SizedBox(
                                width: 25,
                              ),

                              // title
                              const Text(
                                "TeleBirr",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // spacer
                      const SizedBox(height: 24),

                      // pay with stripe
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          // initiate stripe payment
                          await payWithStripe(context);

                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black38,

                            // Make rounded corners
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                  1.0,
                                ),
                                child: Container(
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                        48,
                                      ),
                                      child: Image.asset(
                                        'assets/images/stripe.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // spacer
                              const SizedBox(
                                width: 25,
                              ),

                              const Text(
                                "Card",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // spacer
                      const SizedBox(height: 24),

                      // pay with paypal
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          // initiate paypal
                          await payWithPayPal();

                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black38,

                            // Make rounded corners
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                        48,
                                      ),
                                      child: Image.asset(
                                        'assets/images/pay_pal.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // spacer
                              const SizedBox(
                                width: 25,
                              ),
                              const Text(
                                "PayPal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider()
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
