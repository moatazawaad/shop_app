import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/shared/components/components.dart';
import '../../refresh.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class CartsScreen extends StatelessWidget {
  // CartsScreen({Key? key}) : super(key: key);

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  CartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status!) {
            showToast(text: state.model.message, state: ToastStates.error);
          } else {
            showToast(text: state.model.message, state: ToastStates.success);
          }
        }
        if (state is ShopSuccessChangeCartsState) {
          if (!state.model.status!) {
            showToast(text: state.model.message, state: ToastStates.error);
          } else {
            showToast(text: state.model.message, state: ToastStates.success);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
              ShopCubit.get(context).cartsModel!.data!.cartItems!.isNotEmpty,
          builder: (context) => Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.grey[200],
              title: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            'In Cart',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '3',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    myDivider(),
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'EGP',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${ShopCubit.get(context).cartsModel!.data!.total}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                ShopCubit.get(context).getCarts();
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                //shrinkWrap: true,
                //primary: false,
                //addAutomaticKeepAlives: false,
                itemBuilder: (context, index) => buildCartItem(
                    ShopCubit.get(context).cartsModel!.data!.cartItems![index],
                    context),
                // separatorBuilder: (context, index) => myDivider(),
                itemCount:
                    ShopCubit.get(context).cartsModel!.data!.cartItems!.length,
              ),
            ),
            backgroundColor: Colors.grey[200],
            bottomNavigationBar: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.orange,
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        //   child: IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(
                        //       Icons.call,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        // Spacer(),
                        Container(
                          width: 250,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'CHECKOUT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'EGP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${ShopCubit.get(context).cartsModel!.data!.total}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
