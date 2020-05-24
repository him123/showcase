import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color color;
  final double elevation;
  final double borderRadius;
  final Color titleColor;

  const CustomButton(
      {Key key,
      @required this.onPressed,
      @required this.title,
      this.color,
      this.elevation,
      this.borderRadius,
      this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: double.infinity,
      child: RawMaterialButton(
        elevation: elevation ?? 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
        padding: EdgeInsets.only(
          top: 16,
          bottom: 16,
        ),
        onPressed: onPressed,
        fillColor: color ?? Colors.white,
        child: Text(
          title,
          style: TextStyle(
            color: titleColor ?? Color(0xff4a4a4a),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
