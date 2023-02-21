import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/modules/search/search_screen.dart';
import 'package:flutter_udemy_shop_app/shared/components/components.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/cubit.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/states.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          var cubit = ShopCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.orange,
              title: Row(
                children: const [
                  Text(
                    'Salla',
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.shopping_basket,
                    size: 20,
                    color: Colors.deepOrange,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Shop',
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    navigateTo(
                      context,
                      SearchScreen(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    //  color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // IconButton(
                //   onPressed: () {
                //     navigateTo(
                //       context,
                //       SettingsScreen(),
                //     );
                //   },
                //   icon: const Icon(
                //     Icons.account_circle_outlined,
                //     // color: Colors.white,
                //   ),
                // ),
              ],
            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottom(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                  ),
                  label: 'Carts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.apps,
                  ),
                  label: 'Categories',
                ),
              ],
            ),
          );
        });
  }
}
