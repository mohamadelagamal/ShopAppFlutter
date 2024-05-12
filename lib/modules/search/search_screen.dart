import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../models/search/search_model.dart';
import '../../shared/cubit/search/cubit.dart';
import '../../shared/cubit/search/states.dart';
import '../../shared/cubit/shop_layout/cubit.dart';

class SearchScreen extends StatelessWidget {
  var fromKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  double lineHeight = 1.4;
  double fontSize =
      14.0; // Assuming a default font size of 14.0 if not specified
  int maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: fromKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultTextField(
                      controller: searchController,
                      type: TextInputType.text,
                      label: 'Search',
                      prefix: Icons.search,
                      context: context,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter text to search';
                        }
                        return null;
                      },
                      submit: (String value) {
                        if (fromKey.currentState!.validate()) {
                          cubit.search(searchController.text);
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchLoadingState) LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildProductItem(
                              cubit.searchModel!.data!.data![index], context),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: cubit.searchModel!.data!.data!.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProductItem(Product favoritesModel, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage('${favoritesModel!.image}'),
                    width: 120,
                    height: 120.0,
                  ),
                  if (favoritesModel!.discount != 0)
                    Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'DISCOUNT',
                        style: TextStyle(fontSize: 8.0, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(
                  width:
                      10.0), // Add some space between the image and the text (10 pixels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: maxLines *
                          lineHeight *
                          fontSize, // Calculate the height based on maxLines, lineHeight and fontSize
                      child: Text(
                        '${favoritesModel!.name}',
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(height: lineHeight, fontSize: fontSize),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          '${favoritesModel!.price}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blue),
                        ),
                        SizedBox(width: 5.0),

                        Spacer(), // spacer use to make the space between the two widgets
                        IconButton(
                          onPressed: () {
                            ShopLayoutCubit.get(context)
                                .changeFavourites(favoritesModel!.id!);
                          },
                          icon: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: ShopLayoutCubit.get(context)
                                    .favourite[favoritesModel!.id!]!
                                ? Colors.red
                                : Colors.grey,
                            child: Icon(
                              Icons.favorite_border_outlined,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
