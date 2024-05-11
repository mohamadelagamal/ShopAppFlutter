import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search/search_model.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/search/states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../network/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  void search(String text) {
    emit(SearchLoadingState());
    //get Data from API
    DioHelper.postData(
            path: SEARCH,
            token: token,
            data: {'text': text}
    )
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }

  void changeIndex(int index) {
    emit(SearchChangeIndexState(index));
  }
}
