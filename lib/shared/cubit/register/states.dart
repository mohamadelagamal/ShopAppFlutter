
import '../../../models/shop_app/login_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates {}
// loading
class ShopRegisterLoadingState extends ShopRegisterStates {}
// success
class ShopRegisterSuccessState extends ShopRegisterStates {

  final ShopLoginModel registerModel;
  ShopRegisterSuccessState(this.registerModel);
}
// error
class ShopRegisterErrorState extends ShopRegisterStates {
  final String error;

  ShopRegisterErrorState(this.error);
}
//password visibility
class ShopRegisterChangePasswordVisibilityState extends ShopRegisterStates {}
