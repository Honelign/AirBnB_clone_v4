/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_sdk/flutter_paypal_sdk.dart';

import 'package:kin_music_player_app/screens/payment/paypal/paypalview.dart';

class makePayment extends StatefulWidget {
  @override
  _makePaymentState createState() => _makePaymentState();
}

class _makePaymentState extends State<makePayment> {
  TextStyle style = const TextStyle(fontFamily: 'Open Sans', fontSize: 15.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: AppBar(
              backgroundColor: Colors.white,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Paypal Payment Example',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red[900],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans'),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        await payNow();
                        // make PayPal payment

                        /*  Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment(
                              onFinish: (number) async {
                                // payment done
                            
                              },
                            ),
                          ), */
                      },
                      child: const Text(
                        'Pay with Paypal',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  payNow() async {
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
        Future successFunction() async {
          print("@@@@lookie - payment success -paypal");
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaypalWebview(

              approveUrl: payment.approvalUrl!,
              executeUrl: payment.executeUrl!,
              accessToken: accessToken.token!,
              sdk: sdk,
              successFunction: successFunction,
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
            "total": "10",
          },
        }
      ],
    };

    return transactions;
  }
}
 */