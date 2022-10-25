import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/components/acc_alt_option.dart';
import 'package:kin_music_player_app/screens/login_signup/components/custom_elevated_button.dart';
import 'package:kin_music_player_app/screens/login_signup/components/enter_full_name.dart';
import 'package:kin_music_player_app/screens/login_signup/components/reusable_divider.dart';
import 'package:kin_music_player_app/screens/login_signup/components/social_login.dart';
import 'package:kin_music_player_app/services/network/regi_page.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:country_pickers/country_pickers.dart';
class PhoneNumberLogin extends StatefulWidget {
  PhoneNumberLogin({Key? key}) : super(key: key);

  @override
  State<PhoneNumberLogin> createState() => _PhoneNumberLoginState();
}

class _PhoneNumberLoginState extends State<PhoneNumberLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneNumberFormKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController prefix = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      

    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: getProportionateScreenHeight(35),
              ),
              Form(
                key: _phoneNumberFormKey,
      
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: _buildKinForm(
                  context,
                  // hint: "",
                  controller: phoneNumber,
                  headerTitle: 'Phone Number',
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(35)),
              CustomElevatedButton(
                onTap: () async {
                  print( '+'+_selectedDialogCountry.phoneCode+ phoneNumber.text);
                  if (_phoneNumberFormKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EnterFullName(phoneNumber: '+'+_selectedDialogCountry.phoneCode+ phoneNumber.text),
                      ),
                    );
                  } else if (_phoneNumberFormKey.currentState!.validate()) {}
                },
                text: 'Proceed to OTP',
              ),
              SizedBox(
                height: getProportionateScreenHeight(25),
              ),
              const ReusableDivider(),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              const SocialLogin(),
              AccAltOption(
                buttonText: 'Register',
                leadingText: 'Don\'t have an account ?',
                onTap: () {
                  Navigator.pushNamed(context, RegPage.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildKinForm(
    context, {
    headerTitle,
    hint,
    controller,
  }) {
  
    return Container(
     
      margin: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(10),
        horizontal: getProportionateScreenWidth(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            headerTitle!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           GestureDetector(
                      onTap: _openCountryPickerDialog,
                      child:Text('+${_selectedDialogCountry.phoneCode}',style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w700,fontSize: 15),),
                    ),
                    SizedBox(width: 10,),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This Field is required';
                    }

                    // if (headerTitle == 'Phone Number' &&
                    //     !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                    //         .hasMatch(phoneNumber.text)) {
                    //   return "Phone number must be a number";
                    // }
                    // if (headerTitle == 'Phone Number' &&
                    //     !phoneNumber.text.startsWith('+', 0)) {
                    //   return "Start with +";
                    // }
                    if (headerTitle == 'Phone Number' &&
                        phoneNumber.text.length < 9) {
                      return "Phone Number  digit should be 9";
                    }
                  },
                 
                  onFieldSubmitted: (va) {},
                  keyboardType: TextInputType.number,
                  controller: controller,
                  style: const TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLength: 9,
                  maxLines: 1,
                  cursorColor: kLightTextColor,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(fontSize: 14, color: kGrey),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kGrey,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
    Widget _buildCupertinoItem(Country country) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: CupertinoColors.white,
        fontSize: 16.0,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 8.0),
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      ),
    );
  }
       Country _selectedCupertinoCountry =
      CountryPickerUtils.getCountryByIsoCode('et');

         void _openCupertinoCountryPicker() => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CountryPickerCupertino(

          backgroundColor:  Colors.transparent,
          itemBuilder: _buildCupertinoItem,
          pickerSheetHeight: 250.0,
          pickerItemHeight: 75,
          initialCountry: _selectedCupertinoCountry,
          onValuePicked: (Country country) =>
              setState(() => _selectedCupertinoCountry = country),
          priorityList: [
            CountryPickerUtils.getCountryByIsoCode('ET'),
            CountryPickerUtils.getCountryByIsoCode('US'),
          ],
        );
      });
       Widget _buildCupertinoSelectedItem(Country country) {
    return   Text("+${country.phoneCode}");
  }
   Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('251');
    void _openCountryPickerDialog() => showDialog(
      //barrierColor: Colors.white,
        context: context,
        builder: (context) => CountryPickerDialog(


          titlePadding: EdgeInsets.all(8.0),
          
          // searchInputDecoration: InputDecoration(hintText: 'Search...'),
          // isSearchable: true,
          title: Text('Select your phone code'),
          onValuePicked: (Country country) =>
              setState(() => _selectedDialogCountry = country),
          itemBuilder: _buildDialogItem1,
          priorityList: [
            CountryPickerUtils.getCountryByIsoCode('ET'),
            CountryPickerUtils.getCountryByIsoCode('US'),
          ],
        ),
      );
 Widget _buildDialogItem1(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );
       Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
       
          Text("+${country.phoneCode}",style: TextStyle(color: Colors.white),),
         
        ],
      );
}
