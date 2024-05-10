import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/categories/categories_model.dart';
import '../../shared/cubit/shop_layout/cubit.dart';
import '../../shared/cubit/shop_layout/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopLayoutCubit.get(context);
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildCategoryItem(cubit.categoriesModel!.data!.categories[index]),
          separatorBuilder: (context, index) => Divider(),
          itemCount: cubit.categoriesModel!.data!.categories.length,
        );
      },
    );
  }

  Widget buildCategoryItem(CategoryModel categoryModel) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image.network(
          '${categoryModel.image}',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        SizedBox(width: 20),
        Text(
          '${categoryModel.name}',
          style: TextStyle(fontSize: 20),
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ],
    ),
  );
}
