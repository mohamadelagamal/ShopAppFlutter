
import 'package:shop_app/models/favourites/change_favourites.dart';

import '../../../models/shop_app/login_model.dart';

abstract class ShopLayoutStates {}

class ShopLayoutInitialState extends ShopLayoutStates {}

class ShopLayoutChangeBottomNavState extends ShopLayoutStates {}

class ShopLayoutChangeIndexState extends ShopLayoutStates {}

// get data from API Home data
// 1- loading
class ShopLayoutLoadingHomeDataState extends ShopLayoutStates {}
// 2- success
class ShopLayoutSuccessHomeDataState extends ShopLayoutStates {}
// 3- error
class ShopLayoutErrorHomeDataState extends ShopLayoutStates {}

// get data from API Categories data
// 1- loading
class ShopLayoutLoadingCategoriesDataState extends ShopLayoutStates {}
// 2- success
class ShopLayoutSuccessCategoriesDataState extends ShopLayoutStates {}
// 3- error
class ShopLayoutErrorCategoriesDataState extends ShopLayoutStates {}

// get data from API Favourites data
// 1- loading
class ShopLayoutLoadingFavouritesDataState extends ShopLayoutStates {
   final ChangeFavouritesModel changeFavouritesModel;

    ShopLayoutLoadingFavouritesDataState(this.changeFavouritesModel);
}
// 2- success
class ShopLayoutSuccessFavouritesDataState extends ShopLayoutStates {}
// 3- error
class ShopLayoutErrorFavouritesDataState extends ShopLayoutStates {}

// get data from API Favorites data
// 1- loading
class ShopLayoutGetLoadingFavoritesDataState extends ShopLayoutStates {}
// 2- success
class ShopLayoutGetSuccessFavoritesDataState extends ShopLayoutStates {}
// 3- error
class ShopLayoutGetErrorFavoritesDataState extends ShopLayoutStates {}

// get data from API Profile data
// 1- loading
class ShopLayoutLoadingProfileDataState extends ShopLayoutStates {}
// 2- success
class ShopLayoutSuccessProfileDataState extends ShopLayoutStates {
  final ShopLoginModel shopLoginModel;

  ShopLayoutSuccessProfileDataState(this.shopLoginModel);
}
// 3- error
class ShopLayoutErrorProfileDataState extends ShopLayoutStates {}
