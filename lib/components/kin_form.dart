import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

// ignore: must_be_immutable
class KinForm extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  bool? hasIcon;
  bool? obscureText;
  final String? headerTitle;

  KinForm({
    Key? key,
    required this.hint,
    required this.controller,
    this.hasIcon = false,
    this.obscureText = true,
    this.headerTitle = '',
  }) : super(key: key);

  @override
  State<KinForm> createState() => _KinFormState();
}

class _KinFormState extends State<KinForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(10),
        horizontal: getProportionateScreenWidth(15),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGrey, width: 1.75),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            widget.headerTitle!,
            style: TextStyle(
              color:
                  widget.obscureText == false ? kSecondaryColor : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          // Text Form with Validator
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Empty field is not valid';
              }
              return null;
            },
            cursorColor: kLightTextColor,
            style: const TextStyle(
              color: kSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
            controller: widget.controller,
            obscureText: widget.hasIcon! ? widget.obscureText! : false,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              suffixIcon: widget.hasIcon!
                  ? !widget.obscureText!
                      ? IconButton(
                          onPressed: () {
                            setState(
                              () {
                                widget.obscureText = true;
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.visibility,
                            color: kSecondaryColor,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.visibility_off,
                            color: kLightTextColor,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                widget.obscureText = false;
                              },
                            );
                          },
                        )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              hintStyle: const TextStyle(color: kGrey),
              contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10),
                vertical: getProportionateScreenHeight(10),
              ),
              hintText: widget.hint,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
            ),
          )
        ],
      ),
    );
  }
}
