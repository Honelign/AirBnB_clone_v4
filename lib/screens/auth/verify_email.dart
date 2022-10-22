// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
// import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
// import 'package:kin_music_player_app/constants.dart';
// import 'package:kin_music_player_app/screens/login_signup/components/bezierContainer.dart';
// import 'package:kin_music_player_app/screens/login_signup/login_signup_body.dart';

// class VerifyEmail extends StatefulWidget {
//   static String routeName = 'verifyEmail';
//   final bool flowIsFromLogin;
//   const VerifyEmail({Key? key, this.flowIsFromLogin = true}) : super(key: key);

//   @override
//   State<VerifyEmail> createState() => _VerifyEmail();
// }

// class _VerifyEmail extends State<VerifyEmail> {
//   bool isRechecking = false;
//   bool isEmailVerified = false;
//   Timer? checkEmailVerifiedTimer;

//   int resendWaitTime = 0;
//   bool canResendVerification = false;
//   Timer? updateResendAwaitTime;
//   Timer? resendTimeCounter;

//   Future updateResendTime() async {}

//   Future checkIfEmailVerified() async {
//  
//     try {
//       if (FirebaseAuth.instance.currentUser != null) {
//         await FirebaseAuth.instance.currentUser!.reload();
//       }
//       setState(() {
//         isEmailVerified = FirebaseAuth.instance.currentUser != null
//             ? FirebaseAuth.instance.currentUser!.emailVerified
//             : false;
//       });

//       if (isEmailVerified) {
//         checkEmailVerifiedTimer?.cancel();
//         return const CustomBottomAppBar();
//       }
//     } catch (e) {
//      
//     }
//   }

//   Future sendVerificationEmail() async {
//     try {
//     
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         await currentUser.sendEmailVerification();
//       }
//    
//     } catch (e) {
//      
//     }
//   }

//   String formatRemainingTime(int time) {
//     int minute = (resendWaitTime / 60).floor();
//     int second = (resendWaitTime % 60);

//     String formattedTime = "";

//     if (minute < 10) {
//       formattedTime = "${formattedTime}0$minute:";
//     } else {
//       formattedTime = "$formattedTime$minute:";
//     }

//     if (second < 10) {
//       formattedTime = "${formattedTime}0$second";
//     } else {
//       formattedTime = formattedTime + second.toString();
//     }

//     if (second == 0 && minute == 0) {
//       formattedTime = "";
//     }
//     return formattedTime;
//   }

//   void handleVerificationTiming() async {
//     await Future.delayed(Duration(seconds: resendWaitTime));
//     setState(() {
//       canResendVerification = true;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (!widget.flowIsFromLogin) {
//       resendWaitTime = 60;
//     }

//     resendTimeCounter = Timer.periodic(
//         const Duration(seconds: 1),
//         (_) => {
//               if (resendWaitTime > 0)
//                 {
//                   setState(() {
//                     resendWaitTime = resendWaitTime - 1;
//                   })
//                 }
//             });

//     handleVerificationTiming();

//     isEmailVerified = FirebaseAuth.instance.currentUser != null
//         ? FirebaseAuth.instance.currentUser!.emailVerified
//         : false;

//     sendVerificationEmail();

//     // checkEmailVerifiedTimer = Timer.periodic(
//     //   const Duration(seconds: 3),
//     //   (_) => checkIfEmailVerified(),
//     // );
//   }

//   @override
//   void dispose() {
//     checkEmailVerifiedTimer?.cancel();
//     resendTimeCounter?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         setState(() {
//           isRechecking = true;
//         });
//         if (FirebaseAuth.instance.currentUser != null &&
//             FirebaseAuth.instance.currentUser!.emailVerified == true) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CustomBottomAppBar(),
//             ),
//           );
//         } else {
//           kShowToast(message: "Email not verified Yet!");
//         }
//         isRechecking = false;
//       },
//       child: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return KinProgressIndicator();
//             } else {
//               return SafeArea(
//                 child: Scaffold(
//                   body: isRechecking == true
//                       ? const KinProgressIndicator()
//                       : ListView(
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               height: MediaQuery.of(context).size.height,
//                               padding:
//                                   const EdgeInsets.fromLTRB(32, 40, 32, 60),
//                               color: kPrimaryColor,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       // logout button
//                                       InkWell(
//                                         onTap: () async {
//                                           try {
//                                             // clear shared preferences
//                                             SharedPreferences pref =
//                                                 await SharedPreferences
//                                                     .getInstance();

//                                             var id = pref.getString('id');

//                                             if (id != null) {
//                                               pref.remove('id');
//                                               pref.remove('name$id');
//                                               pref.remove('email$id');
//                                             }

//                                             // logout firebase
//                                             FirebaseAuth.instance.signOut();

//                                             // route to login page
//                                             Navigator.of(context)
//                                                 .pushReplacement(
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     const LoginSignupBody(),
//                                               ),
//                                             );
//                                           } catch (e) {
//                                             // route to login page
//                                             Navigator.of(context)
//                                                 .pushReplacement(
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     const LoginSignupBody(),
//                                               ),
//                                             );
//                                           }

//                                        
//                                         },
//                                         child: Column(
//                                           children: [
//                                             const Icon(
//                                               Icons.logout,
//                                               color: Colors.white,
//                                             ),
//                                             Text(
//                                               "Logout",
//                                               style: TextStyle(
//                                                 color: Colors.white.withOpacity(
//                                                   0.75,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),

//                                   // info section
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // Header
//                                       const Text(
//                                         "Verify Email",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 32,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textAlign: TextAlign.start,
//                                       ),
//                                       // spacer
//                                       const SizedBox(
//                                         height: 12,
//                                       ),

//                                       // More info
//                                       Text(
//                                         "An email has been sent to your email address ${FirebaseAuth.instance.currentUser!.email ?? ''}. Please click on the link sent to your email to verify your account. Refresh the page after you clicked on the link.",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                         ),
//                                       ),

//                                       const SizedBox(
//                                         height: 6,
//                                       ),

//                                       // Spacer
//                                       const SizedBox(
//                                         height: 6,
//                                       ),
//                                       //
//                                       resendWaitTime != 0
//                                           ? Text(
//                                               "Resend in ${formatRemainingTime(resendWaitTime)}",
//                                               style: TextStyle(
//                                                 color: Colors.white
//                                                     .withOpacity(0.65),
//                                                 fontSize: 16,
//                                               ),
//                                             )
//                                           : Container(),

//                                       const SizedBox(
//                                         height: 32,
//                                       ),

//                                       // action buttons
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           // Resend Button
//                                           InkWell(
//                                             onTap: () {
//                                               if (canResendVerification ==
//                                                   true) {
//                                                 resendWaitTime = 300;
//                                                 canResendVerification = false;
//                                                 sendVerificationEmail();
//                                                 handleVerificationTiming();
//                                               } else {
//                                                 kShowToast(
//                                                     message: "Please wait ");
//                                               }
//                                             },
//                                             child: Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                 vertical: 16,
//                                                 horizontal: 40,
//                                               ),
//                                               child: const Text(
//                                                 "Resend Email",
//                                                 style: TextStyle(
//                                                   fontSize: 20,
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                               color:
//                                                   canResendVerification == true
//                                                       ? kSecondaryColor
//                                                       : Colors.grey,
//                                             ),
//                                           ),

//                                           // Logout button
//                                         ],
//                                       ),

//                                       // Spacer
//                                       const SizedBox(
//                                         height: 24,
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               );
//             }
//           }),
//     );
//   }
// }
