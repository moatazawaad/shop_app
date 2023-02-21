import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/carts_model.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/categories_model.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/change_favorites_model.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/favorites_model.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/home_model.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/login_model.dart';
import 'package:flutter_udemy_shop_app/modules/categories/categories_screen.dart';
import 'package:flutter_udemy_shop_app/modules/favorites/favorites_screen.dart';
import 'package:flutter_udemy_shop_app/modules/products/products_screen.dart';
import 'package:flutter_udemy_shop_app/modules/settings/setting_screen.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/states.dart';
import 'package:flutter_udemy_shop_app/shared/network/end_points.dart';
import 'package:flutter_udemy_shop_app/shared/network/remote/dio_helper.dart';
import '../../models/shop_app/change_cart_model.dart';
import '../../models/shop_app/product_details_model.dart';
import '../../modules/cart/cart_screen.dart';
import '../components/constants.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  final controller = PageController(
    initialPage: 3,
    keepPage: false,
  );

  int currentIndex = 2;

  List<Widget> bottomScreens = [
    SettingsScreen(),
    const FavoritesScreen(),
    ProductsScreen(),
    CartsScreen(),
    const CategoriesScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    // if (index == 0) getUserData();
    // if (index == 1) getFavorites();
    // if (index == 2) getHomeData();
    // if (index == 3) getCarts();
    // if (index == 4) getCategories();
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  Map<int, bool> carts = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      }

      for (var element in homeModel!.data!.products) {
        carts.addAll({
          element.id!: element.inCart!,
        });
      }
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      //print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: getCategory,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      //print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: favourites,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      // print(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;

      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: favourites,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      // printFullText(value.data.toString());
      // print(favoritesModel!.status);
      // print(favoritesModel!.message);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      //print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      // printFullText(userModel!.data!.name);
      // printFullText(value.data.toString());
      // print(userModel!.status);
      // print(userModel!.message);
      // print(userModel!.data!.name.toString());
      // print(value.data);

      emit(ShopSuccessUserDataState());
    }).catchError((error) {
      //print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateState());

    DioHelper.putData(
      url: updateProf,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      // printFullText(userModel!.data!.name);
      // printFullText(value.data.toString());
      // print(userModel!.status);
      // print(userModel!.message);
      // print(userModel!.data!.name.toString());
      // print(value.data);

      emit(ShopSuccessUpdateState(userModel!));
    }).catchError((error) {
      //print(error.toString());
      emit(ShopErrorUpdateState());
    });
  }

  CartsModel? cartsModel;

  void getCarts() {
    emit(ShopLoadingGetCartsState());

    DioHelper.getData(
      url: myCarts,
      token: token,
    ).then((value) {
      cartsModel = CartsModel.fromJson(value.data);
      // printFullText(value.data.toString());
      //print(cartsModel!.status);
      // print(cartsModel!.message);
      // print(cartsModel!.data!.total);

      emit(ShopSuccessGetCartsState());
    }).catchError((error) {
      //print(error.toString());
      emit(ShopErrorGetCartsState());
    });
  }

  ChangeCartsModel? changeCartsModel;

  void changeCarts(int productId) {
    carts[productId] = !carts[productId]!;

    emit(ShopChangeCartsState());

    DioHelper.postData(
      url: myCarts,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeCartsModel = ChangeCartsModel.fromJson(value.data);
      //print(changeCartsModel!.message);
      //print(changeCartsModel!.status);

      if (!changeCartsModel!.status!) {
        carts[productId] = !carts[productId]!;
      } else {
        getCarts();
      }

      emit(ShopSuccessChangeCartsState(changeCartsModel!));
    }).catchError((error) {
      carts[productId] = !carts[productId]!;

      emit(ShopErrorChangeCartsState());
    });
  }

  int quantity = 1;

  void minusQuantity() {
    quantity++;
    emit(ShopPlusQuantityState(quantity));
  }

  void plusQuantity() {
    quantity--;
    emit(ShopMinusQuantityState(quantity));
  }

  ProductDetailsModel? detailsModel;

  void getDetails() {
    emit(DetailsLoadingState());

    DioHelper.getData(
      url: details,
      token: token,
    ).then((value) {
      detailsModel = ProductDetailsModel.fromJson(value.data);
      emit(DetailsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(DetailsErrorState());
    });
  }
}
