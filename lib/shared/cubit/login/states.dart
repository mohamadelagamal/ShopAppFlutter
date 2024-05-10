import 'package:shop_app/models/shop_app/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates {}
// loading
class ShopLoginLoadingState extends ShopLoginStates {}
// success
class ShopLoginSuccessState extends ShopLoginStates {

  final ShopLoginModel loginModel;
  ShopLoginSuccessState(this.loginModel);
}
// error
class ShopLoginErrorState extends ShopLoginStates {
  final String error;

  ShopLoginErrorState(this.error);
}
//password visibility
class ShopLoginChangePasswordVisibilityState extends ShopLoginStates {}
