import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);
Widget defaultTextField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? submit,
  Function(String)? change,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  bool isPassword =false,
  IconData? suffix,
  VoidCallback? suffixPressed,
  required BuildContext context,

}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  validator: validate,
  onFieldSubmitted: submit,
  onChanged: change,
  style: Theme.of(context).textTheme.bodyText2, // Add this line
  decoration: InputDecoration(
    labelText: label,
    labelStyle: Theme.of(context).textTheme.bodyText2, // Add this line
    border: OutlineInputBorder(),
    prefixIcon: Icon(prefix),
    suffixIcon: IconButton(
      onPressed: suffixPressed,
      icon: Icon(suffix),
    ),
  ),
);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
// show Flutter toast
void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );
void signOut({required context}){
  // sign out
  CacheHelper.removeData(key: 'token').then((value) => {
    if(value)
      {
        navigateAndFinish(context, ShopLoginScreen())
      }

  });
}
void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) {
    print(match.group(0));
  });
}