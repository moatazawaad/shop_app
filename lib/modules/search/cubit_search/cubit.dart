import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/search_model.dart';
import 'package:flutter_udemy_shop_app/modules/search/cubit_search/states.dart';
import 'package:flutter_udemy_shop_app/shared/network/remote/dio_helper.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  // SearchCubit(super.initialState);
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search(String? text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: searchProd,
      token: token,
      data: {
        'text': text,
      },
    )
        .then((value) => {
              searchModel = SearchModel.fromJson(value.data),
              // print(searchModel!.message),
              emit(SearchSuccessState()),
            })
        .catchError((error) {
      //  print(error.toString());
      emit(SearchErrorState());
    });
  }
}
