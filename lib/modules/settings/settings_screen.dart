import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../shared/cubit/shop_layout/cubit.dart';
import '../../shared/cubit/shop_layout/states.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = ShopLayoutCubit.get(context).userModel;
        nameController.text = userModel!.data!.name!;
        emailController.text = userModel.data!.email!;
        phoneController.text = userModel.data!.phone!;

        return ConditionalBuilder(
          condition: userModel != null,
          builder:(context)=> Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if(state is ShopLayoutLoadingProfileDataState)
                  LinearProgressIndicator(),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // Log out button
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: () {
                        signOut(context: context);
                      },
                      child: Text(
                        'LOG OUT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Update button
                  Container(
                    width: double.infinity,
                    color: Colors.deepOrange,
                    child: MaterialButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          ShopLayoutCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                      child: BlocBuilder<ShopLayoutCubit, ShopLayoutStates>(
                        builder: (context, state) {
                          if (state is ShopLayoutUpdateLoadingProfileDataState) {
                            return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            );
                          } else if (state is ShopLayoutUpdateSuccessProfileDataState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'UPDATE',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            );
                          } else {
                            return Text(
                              'UPDATE',
                              style: TextStyle(color: Colors.white),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
