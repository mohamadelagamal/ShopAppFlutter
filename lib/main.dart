import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/app/app_cubit.dart';
import 'package:shop_app/shared/cubit/app/bloc_observer.dart';
import 'package:shop_app/shared/cubit/app/states.dart';
import 'package:shop_app/shared/cubit/shop_layout/cubit.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes/themes.dart';

import 'modules/onboarding/onboarding_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // This is the first line of the main function
  Bloc.observer =
      MyBlocObserver(); // MyBlocObserver is a custom BlocObserver used to observe the state changes in the app
  // initialize the Dio package
  // Dio means Data I/O, it is a powerful Http client for Dart,
  // which supports Interceptors, Global configuration, FormData,
  // Request Cancellation, File downloading, Timeout etc.
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;
  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');

  print('token: $token');


  if(onBoarding!=null){
    if(token != null) widget = ShopLayout();
    else widget = ShopLoginScreen();
  }else{
    widget = OnBoardingScreen();
  }


  runApp(MyApp(
    isDark: isDark ?? false,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final bool isDark;
  final Widget startWidget;
  MyApp({required this.isDark, required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
              AppCubit()..changeAppMode(fromShared: false)),
          BlocProvider(create: (context) => ShopLayoutCubit()..getHomeData()..getCategoriesData()..getFavorites()..getUserData()),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: AppCubit.get(context).isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                home: startWidget,
              );
            }));
  }
}
