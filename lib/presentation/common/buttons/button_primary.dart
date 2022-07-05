import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final double width;
  final double fontSize;
  final void Function()? onPressed;
  final double borderRadius;
  final bool progressIndicator;
  final double verticalPadding;

  ButtonPrimary({
    required this.text,
    this.onPressed,
    required this.width,
    required this.fontSize,
    this.progressIndicator = false,
    this.verticalPadding = 15,
    this.borderRadius = 15, 
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: progressIndicator ? null : onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: width != null ? width : MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: Color(0xFF00B6E6),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: progressIndicator
            ? SizedBox(
                height: 35,
                width: 35,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize != null ? fontSize : 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0,
                  fontFamily: 'Nexa',
                ),
              ),
      ),
    );
  }
}
