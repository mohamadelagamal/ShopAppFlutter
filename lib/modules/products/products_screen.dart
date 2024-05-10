import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories/categories_model.dart';
import 'package:shop_app/models/home/home_model.dart';

import '../../shared/cubit/shop_layout/cubit.dart';
import '../../shared/cubit/shop_layout/states.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopLayoutCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null && cubit.categoriesModel != null,
          builder: (context) => productBuilder(cubit.homeModel!, cubit.categoriesModel!,context),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget productBuilder(HomeModel model,CategoriesModel categoriesModel,context) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            CarouselSlider(
              items: model.data!.banners
                  .map((e) => Image.network(
                        '${e.image}',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 200.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoryItem(
                          categoriesModel.data!.categories[index]
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel.data!.categories.length,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'News Products',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 1 / 1.58,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(model.data!.products.length,
                  (index) => buildGridProduct(model.data!.products[index],context)),
            )
          ],
        ),
      );
  double lineHeight = 1.4;
  double fontSize =
      14.0; // Assuming a default font size of 14.0 if not specified
  int maxLines = 2;

  Widget buildGridProduct(ProductModel model,context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage('${model.image}'),
                width: double.infinity,
                height: 200.0,
              ),
              if (model.discount != 0)
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: maxLines *
                      lineHeight *
                      fontSize, // Calculate the height based on maxLines, lineHeight and fontSize
                  child: Text(
                    '${model.name}',
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: lineHeight, fontSize: fontSize),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${model.price}',
                      style: TextStyle(fontSize: 12.0, color: Colors.blue),
                    ),
                    SizedBox(width: 5.0),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice}',
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    Spacer(), // spacer use to make the space between the two widgets
                    IconButton(
                      onPressed: () {
                        ShopLayoutCubit.get(context)
                            .changeFavourites(model.id!);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: ShopLayoutCubit.get(context)
                                    .favourite[model.id] ==
                                true
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
      );

  Widget buildCategoryItem(CategoryModel categoriesModel) => Container(
        height: 100.0,
        width: 100.0,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage(
                  '${categoriesModel.image}'),
              height: 100.0,
              width: 100.0,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.8),
              width: double.infinity,
              child: Text(
                '${categoriesModel.name}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
