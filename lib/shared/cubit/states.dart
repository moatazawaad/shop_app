import 'package:flutter_udemy_shop_app/models/shop_app/change_favorites_model.dart';

import '../../models/shop_app/change_cart_model.dart';
import '../../models/shop_app/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopPlusQuantityState extends ShopStates {
  late final int counter;
  ShopPlusQuantityState(this.counter);
}

class ShopMinusQuantityState extends ShopStates {
  late final int counter;
  ShopMinusQuantityState(this.counter);
}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingGetCartsState extends ShopStates {}

class ShopSuccessGetCartsState extends ShopStates {}

class ShopErrorGetCartsState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  // final ShopLoginModel loginModel;
  //
  // ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUpdateState extends ShopStates {}

class ShopSuccessUpdateState extends ShopStates {
  final ShopLoginModel loginModel;

  ShopSuccessUpdateState(this.loginModel);
}

class ShopErrorUpdateState extends ShopStates {}

class ShopChangeCartsState extends ShopStates {}

class ShopSuccessChangeCartsState extends ShopStates {
  final ChangeCartsModel model;

  ShopSuccessChangeCartsState(this.model);
}

class ShopErrorChangeCartsState extends ShopStates {}

class DetailsLoadingState extends ShopStates {}

class DetailsSuccessState extends ShopStates {}

class DetailsErrorState extends ShopStates {}
