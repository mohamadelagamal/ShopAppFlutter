
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/cubit/login/states.dart';

import '../../../models/shop_app/login_model.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      path: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel= ShopLoginModel.fromJson(value.data);

      print(
          'loginModel: ${loginModel!.status} ${loginModel!.message} ${loginModel!.data!.token}'
      );

      emit(ShopLoginSuccessState(loginModel!));


    }).catchError((error) {
      print(error.toString());
      emit(ShopLoginErrorState(loginModel!.message!.toString()));
    });
  }
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ShopLoginChangePasswordVisibilityState());
  }
}