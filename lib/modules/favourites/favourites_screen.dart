import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/favourites/favourites_model.dart';

import '../../shared/cubit/shop_layout/cubit.dart';
import '../../shared/cubit/shop_layout/states.dart';

class FavouritesScreen extends StatelessWidget {
  double lineHeight = 1.4;
  double fontSize =
      14.0; // Assuming a default font size of 14.0 if not specified
  int maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopLayoutCubit.get(context);
        return ConditionalBuilder(
          condition: state is! ShopLayoutGetLoadingFavoritesDataState,
          builder:(context)=> ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildFavouritesItem(
                cubit.favouritesModel!.data!.data![index], context),
            separatorBuilder: (context, index) => Divider(),
            itemCount: cubit.favouritesModel!.data!.data!.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildFavouritesItem(FavouritesData favoritesModel, context) => Padding(
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
                    image: NetworkImage('${favoritesModel.product!.image}'),
                    width: 120,
                    height: 120.0,

                  ),
                  if (favoritesModel.product!.discount != 0)
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
                        '${favoritesModel.product!.name}',
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
                          '${favoritesModel.product!.price}',
                          style: TextStyle(fontSize: 12.0, color: Colors.blue),
                        ),
                        SizedBox(width: 5.0),
                        if (1 != 0)
                          Text(
                            '${favoritesModel.product!.oldPrice}',
                            style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                        Spacer(), // spacer use to make the space between the two widgets
                        IconButton(
                          onPressed: () {
                            ShopLayoutCubit.get(context)
                                .changeFavourites(favoritesModel.product!.id!);
                          },
                          icon: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: ShopLayoutCubit.get(context)
                                    .favourite[favoritesModel.product!.id!]!
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
