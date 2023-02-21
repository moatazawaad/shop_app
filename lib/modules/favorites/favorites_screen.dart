import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
              ShopCubit.get(context).favoritesModel!.data!.data!.isNotEmpty,
          builder: (context) => buildGetFavorites(
            favors: ShopCubit.get(context).favoritesModel!.data!.data,
          ),
          fallback: (context) => Center(
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(
                  Icons.shopping_basket,
                  size: 20,
                  color: Colors.orange,
                ),
                CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
