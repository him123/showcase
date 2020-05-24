import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';


class PaymentMethodItem extends StatelessWidget {
  final String account;
  final String imageName;
  final bool checked;
  final Function onTap;

  const PaymentMethodItem(
      {Key key,
      @required this.account,
      @required this.imageName,
      @required this.checked,
      @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: checked ? Color(0xffe7f9f5) : Color(0xfff5f8fb),
          border: Border.all(
              color: checked ? kColorGreen : Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/$imageName',
              width: 33,
              height: 30,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                account,
                style: TextStyle(
                  color: kColorBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: checked,
              child: Icon(
                Icons.check_circle,
                color: kColorGreen,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
