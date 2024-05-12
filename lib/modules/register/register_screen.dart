import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubit/register/cubit.dart';
import '../../shared/cubit/register/states.dart';
import '../../shared/network/local/cache_helper.dart';
import '../basics/conditional_builder.dart';

class ShopRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  bool isPasswordVisible = false; // add this line

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {

          if (state is ShopRegisterSuccessState) {
            if (state.registerModel.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.registerModel.data!.token,
              ).then((value) {
                // refresh the token value in the cache
                token = state.registerModel.data!.token!;
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                  text: state.registerModel.message!, state: ToastStates.ERROR);
            }
          } else if (state is ShopRegisterErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }

        },
        builder: (context, state) {
          // update token
          var cubit = ShopRegisterCubit.get(context);
          // update token
          token = cubit.registerModel!.data!.token!;
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
                          Text('REGISTER',
                              style: Theme.of(context).textTheme.headline4),
                          SizedBox(height: 10),
                          Text('Register now to browse our hot offers',
                              style: Theme.of(context).textTheme.bodyText2),
                          SizedBox(height: 50),
                          defaultTextField(
                              controller: nameController,
                              type: TextInputType.text,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                              },
                              label: 'Name',
                              prefix: Icons.person,
                              context: context),
                          SizedBox(height: 15),
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
                              ShopRegisterCubit.get(context).isPassword,
                              context: context,
                              suffixPressed: () {
                                isPasswordVisible = !isPasswordVisible;
                                ShopRegisterCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              submit: (String value) {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              }),
                          // Add phone number field
                          SizedBox(height: 15),
                          defaultTextField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                              },
                              label: 'Phone Number',
                              prefix: Icons.phone,
                              context: context),
                          SizedBox(height: 30),
                          ConditionalBuilder(
                            condition: state is! ShopRegisterLoadingState,
                            trueBuilder: (context) => Container(
                              width: double.infinity,
                              color: Colors.deepOrange,
                              child: MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                child: Text('REGISTER',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            falseBuilder: (context) =>
                                Center(child: CircularProgressIndicator()),
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
