import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/favourites/change_favourites.dart';
import 'package:shop_app/models/favourites/favourites_model.dart';
import 'package:shop_app/models/home/home_model.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/login/states.dart';
import 'package:shop_app/shared/cubit/shop_layout/states.dart';

import '../../../models/categories/categories_model.dart';
import '../../../modules/categories/categories_screen.dart';
import '../../../modules/favourites/favourites_screen.dart';
import '../../../modules/products/products_screen.dart';
import '../../../modules/search/search_screen.dart';
import '../../../modules/settings/settings_screen.dart';
import '../../components/constants.dart';
import '../../network/end_points.dart';
import '../../network/remote/dio_helper.dart';

class ShopLayoutCubit extends Cubit<ShopLayoutStates> {
  ShopLayoutCubit() : super(ShopLayoutInitialState());

  get favourites => null;

  static ShopLayoutCubit get(context) => BlocProvider.of(context);

  HomeModel? homeModel;
  CategoriesModel? categoriesModel;
  ChangeFavouritesModel? changeFavouritesModel;
  FavoritesModel? favouritesModel;
  ShopLoginModel? userModel;
  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Products',
    'Categories',
    'Favourites',
    'Settings',
  ];
  Map<int, bool> favourite = {};

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopLayoutChangeBottomNavState());
  }

  void getHomeData() {
    emit(ShopLayoutLoadingHomeDataState());
    // get Data from API
    DioHelper.getData(path: HOME, token: token)
        .then((value) => {
              homeModel = HomeModel.fromJson(value.data),
              printFullText(homeModel!.data!.banners[0].image.toString()),
              homeModel!.data!.products.forEach((element) {
                favourite.addAll({
                  element.id!: element.inFavorites!,
                });
              }),
              emit(ShopLayoutSuccessHomeDataState()),
            })
        .catchError((error) {
      print(error.toString());
      emit(ShopLayoutErrorHomeDataState());
    });
  }

  // get data from API Categories data
  void getCategoriesData() {
    emit(ShopLayoutLoadingCategoriesDataState());
    // get Data from API
    DioHelper.getData(path: CATEGORIES, token: token)
        .then((value) => {
              categoriesModel = CategoriesModel.fromJson(value.data),
              // printFullText(categoriesModel!.data.data[0].name.toString()),
              emit(ShopLayoutSuccessCategoriesDataState()),
            })
        .catchError((error) {
      print(error.toString());
      emit(ShopLayoutErrorCategoriesDataState());
    });
  }

  void changeFavourites(int productId) {
    // change the value of the favourite map for the product id to the opposite value of the current value of the product id
    favourite[productId] = !favourite[productId]!;
    emit(ShopLayoutSuccessFavouritesDataState());

    DioHelper.postData(
      path: FAVOURITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavouritesModel = ChangeFavouritesModel.fromJson(value.data);
      if (!changeFavouritesModel!.status!) {
        favourite[productId] = !favourite[productId]!;
      } else {
        changeFavouritesModel = ChangeFavouritesModel.fromJson(value.data);
        print(value.data);
        emit(ShopLayoutSuccessFavouritesDataState());
        getFavorites();
      }
      emit(ShopLayoutSuccessFavouritesDataState());
    }).catchError((error) {
      favourite[productId] = !favourite[productId]!;
      emit(ShopLayoutErrorFavouritesDataState());
    });
  }

  void getFavorites() {

    emit(ShopLayoutGetLoadingFavoritesDataState());
    // get Data from API
    DioHelper.getData(path: FAVOURITES, token: token)
        .then((value) => {
      favouritesModel = FavoritesModel.fromJson(value.data),
       printFullText(value.data.toString()),
      emit(ShopLayoutGetSuccessFavoritesDataState()),
    })
        .catchError((error) {
      print(error.toString());
      emit(ShopLayoutGetErrorFavoritesDataState());
    });
  }

  void getUserData() {
    emit(ShopLayoutLoadingProfileDataState());
    DioHelper.getData(path: PROFILE, token: token)
        .then((value) => {
              userModel = ShopLoginModel.fromJson(value.data),
      print(userModel!.data!.name),
              emit(ShopLayoutSuccessProfileDataState(userModel!)),
            })
        .catchError((error) {
      print(error.toString());
      emit(ShopLayoutErrorProfileDataState());
    });
  }

}
