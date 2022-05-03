import 'package:flutter/material.dart';
import 'package:demo_app/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButton extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final String? providerName;

  final Color? buttonColor;
  final Color? buttonTextColor;
  final double? height;
  final IconData? loginIcon;

  SocialButton(
      {required this.onPressed,
      this.providerName,
      this.buttonColor,
      this.buttonTextColor,
      this.height,
      this.loginIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: SizeConstants.horizontalPadding20,
          vertical: SizeConstants.verticalPadding10),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConstants.circularRadius))),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: height),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(SizeConstants.circularBorderRadius)))),
              backgroundColor: MaterialStateProperty.all(buttonColor)),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: FaIcon(loginIcon),
                  onPressed: () {},
                  color: Color(0xFF051419),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
