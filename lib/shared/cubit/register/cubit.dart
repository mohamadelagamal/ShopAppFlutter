
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/shared/cubit/register/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? registerModel;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      path: REGISTER,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      },
    ).then((value) {
      registerModel= ShopLoginModel.fromJson(value.data);

      print(
          'RegisterModel: ${registerModel!.status} ${registerModel!.message} ${registerModel!.data!.token}'
      );

      emit(ShopRegisterSuccessState(registerModel!));


    }).catchError((error) {
      print(error.toString());
      emit(ShopRegisterErrorState(registerModel!.message!.toString()));
    });
  }
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ShopRegisterChangePasswordVisibilityState());
  }
}