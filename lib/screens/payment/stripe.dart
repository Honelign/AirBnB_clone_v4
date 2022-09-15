import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kin_music_player_app/constants.dart';

class StripePayment extends StatefulWidget {
  const StripePayment({Key? key}) : super(key: key);

  @override
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  String SECRET_KEY =
      'sk_test_51LcOtyFvUcclFpL2Isr4xf7kyt67mCFY6LHxNy5mu06kfk5MzcZRU11W6dU211P4XGyMPoYTltDWBrftA3OoFhHz00pPkHiT4s';

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kPrimaryColor,
      body: Center(
        child: TextButton(
          child: Text(
            'Proceed to payment',
            style:
                TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.75)),
          ),
          onPressed: () async {
            await makePayment();
          },
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'kinideas'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('@@ stripe Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('@@ stripe is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('@s@ stripe $e');
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
      // ignore: avoid_print
      print('@@stripe Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('@@ stripe charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}

/* import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


class StripePayment extends StatefulWidget {
  const StripePayment({Key? key}) : super(key: key);

  @override
  State<StripePayment> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  String SECRET_KEY =
      'sk_test_51LcOtyFvUcclFpL2Isr4xf7kyt67mCFY6LHxNy5mu06kfk5MzcZRU11W6dU211P4XGyMPoYTltDWBrftA3OoFhHz00pPkHiT4s';
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: InkWell(
              onTap: () async {
                await makePayment();
              },
              child: Text(
                "pay",
                style: TextStyle(color: Colors.white, fontSize: 24),
              )),
        ));
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  applePay: const PaymentSheetApplePay(
                    merchantCountryCode: '+92',
                  ),
                  googlePay: const PaymentSheetGooglePay(
                      testEnv: true,
                      currencyCode: "USD",
                      merchantCountryCode: '+1'),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Hone'))
          .then((value) {});
      displayPaymentSheet();
    } catch (e) {}
  }

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
    } catch (e) {}
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        Text("Payment Successful"),
                      ],
                    )
                  ]),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        debugPrint("Error " + error.toString() + stackTrace.toString());
      });
    } on StripeException catch (error) {
      debugPrint("Error " + error.toString());
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Text("Cancelled"),
            );
          });
    } catch (e) {
      debugPrint("error occured" + e.toString());
    }
  }
}
 */
