import 'package:flutter/cupertino.dart';
import 'package:flutter_udemy_shop_app/modules/cart/cart_screen.dart';
import 'package:flutter_udemy_shop_app/modules/categories/categories_screen.dart';
import 'package:flutter_udemy_shop_app/modules/favorites/favorites_screen.dart';
import 'package:flutter_udemy_shop_app/modules/products/products_screen.dart';
import 'package:flutter_udemy_shop_app/modules/settings/setting_screen.dart';

import '../../shared/cubit/cubit.dart';

class PageViewScreen extends StatelessWidget {
  const PageViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: ShopCubit.get(context).controller,
      // scrollDirection: Axis.horizontal,
      children: [
        SettingsScreen(),
        const FavoritesScreen(),
        ProductsScreen(),
        CartsScreen(),
        const CategoriesScreen(),
      ],
    );
  }
}
