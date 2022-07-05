import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldDark extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool enabled;
  final Key inputKey;
  final TextEditingController controller;
  final void Function(String?) onChanged;
  final String? Function(String?) validator;
  final void Function()? onTapIcon;
  final String? error;
  final bool obscureText;
  final bool isSuffixIcon;
  final TextInputType keyboardType;
  final void Function()? onTap;
  final TextInputFormatter? formatter;
  final Color? fillColor;
  final bool autofocus;

  TextFieldDark(
      {this.enabled = true,
      this.onTap,
      this.icon,
      this.error,
      required this.inputKey,
      required this.controller,
      required this.hintText,
      required this.onChanged,
      required this.validator,
      this.onTapIcon,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.formatter,
      this.fillColor,
      this.autofocus = false,
      this.isSuffixIcon = true,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      inputFormatters: formatter != null ? [formatter!] : null,
      enableInteractiveSelection: enabled,
      focusNode: enabled ? null : FocusNode(),
      onTap: onTap,
      style: TextStyle(
        color: Color(0xFF6F7177),
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      cursorColor: Color(0xFF00B6E6),
      keyboardType: keyboardType,
      key: inputKey,
      controller: controller,
      decoration: InputDecoration(
        errorText: this.error,
        suffixIcon: isSuffixIcon && icon != null
            ? InkWell(
              onTap: this.onTapIcon,
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(0),
                child: Icon(
                  icon,
                  color: Color(0xFF6F7177),
                  size: 25,
                ),
              ),
            )
            : null,
          prefixIcon: !isSuffixIcon && icon != null
            ? InkWell(
              onTap: this.onTapIcon,
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(0),
                child: Icon(
                  icon,
                  color: Color(0xFF6F7177),
                  size: 25,
                ),
              ),
            )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFF6F7177),
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        contentPadding: EdgeInsets.all(20),
        filled: true,
        fillColor: fillColor != null ? fillColor : Color(0xFF10172F),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Color(0xFF10172F),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Color(0xFF00B6E6),
            width: 1,
          ),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
    );
  }
}
