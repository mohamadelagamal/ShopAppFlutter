import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/basics/conditional_builder.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/login/cubit.dart';
import 'package:shop_app/shared/cubit/login/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

import '../register/register_screen.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false; // add this line

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          //showToast(text: state.toString(), state: ToastStates.ERROR);
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                // refresh the token value in the cache
                token = state.loginModel.data!.token!;
                navigateAndFinish(context, ShopRegisterScreen());
              });
            } else {
              showToast(
                  text: state.loginModel.message!, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LOGIN',
                              style: Theme.of(context).textTheme.headline4),
                          SizedBox(height: 10),
                          Text('Login now to browse our hot offers',
                              style: Theme.of(context).textTheme.bodyText2),
                          SizedBox(height: 50),
                          defaultTextField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email address';
                                }
                              },
                              label: 'Email Address',
                              prefix: Icons.email,
                              context: context),
                          SizedBox(height: 15),
                          defaultTextField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              suffix: isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                              },
                              label: 'Password',
                              prefix: Icons.lock,
                              isPassword:
                                  ShopLoginCubit.get(context).isPassword,
                              context: context,
                              suffixPressed: () {
                                isPasswordVisible = !isPasswordVisible;
                                ShopLoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              submit: (String value) {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              }),
                          SizedBox(height: 30),
                          ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            trueBuilder: (context) => Container(
                              width: double.infinity,
                              color: Colors.deepOrange,
                              child: MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                child: Text('LOGIN',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            falseBuilder: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  // move to shop register screen
                                  navigateTo(context, ShopRegisterScreen());
                                },
                                child: Text('REGISTER NOW'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
