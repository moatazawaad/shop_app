import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/login_model.dart';
import 'package:flutter_udemy_shop_app/modules/shop_login/cubit_login/states.dart';
import 'package:flutter_udemy_shop_app/shared/network/end_points.dart';
import 'package:flutter_udemy_shop_app/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  // void userLogin({
  //   required String email,
  //   required String password,
  // }) {
  //   emit(ShopLoginLoadingState());
  //   DioHelper.postData(
  //     url: LOGIN,
  //     data: {
  //       'email': email,
  //       'password': password,
  //     },
  //   )
  //       .then((value) => {
  //             print(value.data),
  //             emit(ShopLoginSuccessState()),
  //           })
  //       .catchError((error) {
  //     print(error.toString());
  //     emit(ShopLoginErrorState(error.toString()));
  //   });
  // }

  ShopLoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
      url: login,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      //print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
     // print(loginModel!.status);
     // print(loginModel!.message);
      //  دا الى عامل مشكله ان فلاتر توست مع ايرور مبيطبعش عشان ف حاله ميل او بسورد غلط
      // بتيجى التوكن فاضيه ف مبيقدرش يطبع داتا بتشيك عليها وجايه فاضيه
      // print(loginModel!.data!.token);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      //print(error.toString());
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    // معناها عكس قيمتها اعكس القيمه الى هى فيها
    isPassword = !isPassword;

    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopShowPasswordVisibilityState());
  }
}
