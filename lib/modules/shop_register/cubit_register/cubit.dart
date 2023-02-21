import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/modules/shop_register/cubit_register/states.dart';
import 'package:flutter_udemy_shop_app/shared/network/end_points.dart';
import 'package:flutter_udemy_shop_app/shared/network/remote/dio_helper.dart';

import '../../../models/shop_app/login_model.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());

    DioHelper.postData(
      url: register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      //print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      // print(loginModel!.status);
      // print(loginModel!.message);
      //  دا الى عامل مشكله ان فلاتر توست مع ايرور مبيطبعش عشان ف حاله ميل او بسورد غلط
      // بتيجى التوكن فاضيه ف مبيقدرش يطبع داتا بتشيك عليها وجايه فاضيه
      // print(RegisterModel!.data!.token);
      emit(ShopRegisterSuccessState(loginModel!));
    }).catchError((error) {
      //print(error.toString());
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    // معناها عكس قيمتها اعكس القيمه الى هى فيها
    isPassword = !isPassword;

    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopRegisterShowPasswordVisibilityState());
  }
}
