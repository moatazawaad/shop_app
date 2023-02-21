import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/shared/components/components.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/cubit.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
              ShopCubit.get(context).categoriesModel!.data!.data.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildCatItem(
                ShopCubit.get(context).categoriesModel!.data!.data[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount:
                ShopCubit.get(context).categoriesModel!.data!.data.length,
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
