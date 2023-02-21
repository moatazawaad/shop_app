import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/shop_app/carts_model.dart';
import '../../models/shop_app/categories_model.dart';
import '../cubit/cubit.dart';
import '../styles/colors.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ), (route) {
      return false;
    });

Widget loginButton({
  double width = double.infinity,
  Color background = Colors.red,
  bool isUpperCase = true,
  double height = 40.0,
  double radius = 10.0,
  //it was Function but not worked until changed to VoidCallBack
  VoidCallback? function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  FormFieldValidator<String>? onSubmit,
  FormFieldValidator<String>? onChange,
  bool isPassword = false,
  VoidCallback? onTab,
  final String? value,
  final FormFieldValidator<String>? validate,
  required String label,
  required IconData prefixIcon,
  IconData? suffixIcon,
  VoidCallback? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      //  keyboardAppearance: Brightness.dark,
      controller: controller,
      obscureText: isPassword,
      onTap: onTab,
      keyboardType: type,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      // onChanged: (String? value) {
      //   onChange;
      // },
      onChanged: onChange,
      validator: validate,
      decoration: InputDecoration(
        // hintText: 'Email',
        labelText: label,
        // hintStyle: TextStyle(
        //   color: Colors.red,
        // ),
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffixIcon))
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(text.toUpperCase()),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
      child: Container(
        width: double.infinity,
        height: 2.0,
        color: Colors.grey[300],
      ),
    );

Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        // navigateTo(context, WebViewScreen(url: (article['url'])));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: SizedBox(
                height: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${article['title']}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
          ],
        ),
      ),
    );

Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: 10,
      ),
      fallback: (context) => isSearch
          ? Container()
          : const Center(child: CircularProgressIndicator()),
    );

void showToast({
  required String? text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates {
  success,
  error,
  warning,
}

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;

    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

void printFullText(String? text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text!).forEach((match) => print(match.group(0)));
}

// Widget buildListProduct(
//   model,
//   context, {
//   bool isOldPrice = true,
// }) =>
//     Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Container(
//         height: 120.0,
//         child: Row(
//           children: [
//             Stack(
//               alignment: AlignmentDirectional.bottomStart,
//               children: [
//                 Image(
//                   image: NetworkImage(model.image),
//                   width: 120.0,
//                   height: 120.0,
//                 ),
//                 if (model.discount != 0 && isOldPrice)
//                   Container(
//                     color: Colors.red,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 5.0,
//                     ),
//                     child: Text(
//                       'DISCOUNT',
//                       style: TextStyle(
//                         fontSize: 8.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(
//               width: 20.0,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     model.name,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       height: 1.3,
//                     ),
//                   ),
//                   Spacer(),
//                   Row(
//                     children: [
//                       Text(
//                         model.price.toString(),
//                         style: TextStyle(
//                           fontSize: 12.0,
//                           color: defaultColor,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5.0,
//                       ),
//                       if (model.discount != 0 && isOldPrice)
//                         Text(
//                           model.oldPrice.toString(),
//                           style: TextStyle(
//                             fontSize: 10.0,
//                             color: Colors.grey,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       Spacer(),
//                       IconButton(
//                         onPressed: () {
//                           ShopCubit.get(context).changeFavorites(model.id);
//                         },
//                         icon: CircleAvatar(
//                           radius: 15.0,
//                           backgroundColor:
//                               ShopCubit.get(context).favorites[model.id]!
//                                   ? defaultColor
//                                   : Colors.grey,
//                           child: Icon(
//                             Icons.favorite_border,
//                             size: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

// Widget buildFavoriteItem(Product model, context) => Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Container(
//         height: 120.0,
//         child: Row(
//           children: [
//             Stack(
//               alignment: AlignmentDirectional.bottomStart,
//               children: [
//                 Image(
//                   image: NetworkImage(model.image!),
//
//                   width: 120.0,
//
//                   height: 120.0,
//
//                   // fit: BoxFit.cover,
//                 ),
//                 if (model.discount != 0)
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 5.0),
//                     color: Colors.red,
//                     child: Text(
//                       'DISCOUNT',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10.0,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(
//               width: 20.0,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     model.name!,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       height: 1.3,
//                     ),
//                   ),
//                   Spacer(),
//                   Row(
//                     children: [
//                       Text(
//                         model.price!.toString(),
//                         style: TextStyle(
//                           fontSize: 12.0,
//                           color: defaultColor,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5.0,
//                       ),
//                       if (model.discount != 0)
//                         Text(
//                           model.oldPrice!.toString(),
//                           style: TextStyle(
//                             fontSize: 10.0,
//                             color: Colors.grey,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       Spacer(),
//                       IconButton(
//                         // padding: EdgeInsets.zero,
//
//                         onPressed: () {
//                           ShopCubit.get(context).changeFavorites(model.id!);
//                         },
//
//                         icon: CircleAvatar(
//                           radius: 15.0,
//                           backgroundColor:
//                               ShopCubit.get(context).favorites[model.id]!
//                                   ? Colors.red
//                                   : Colors.grey,
//                           child: Icon(
//                             Icons.favorite_border,
//                           ),
//                         ),
//
//                         color: Colors.white,
//
//                         iconSize: 14.0,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

Widget buildSearchItem(model, context, {bool isOldPrice = true}) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CachedNetworkImage(
                  imageUrl: model.image!,
                  width: 120.0,
                  height: 120.0,
                  placeholder: (context, url) => Stack(
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
                  // fit: BoxFit.cover,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price!.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice!.toString(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        // padding: EdgeInsets.zero,

                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id!);
                        },
                        icon: Icon(
                          ShopCubit.get(context).favorites[model.id]!
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget buildGetFavorites({required favors}) => ConditionalBuilder(
      condition: favors.length > 0,
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildSearchItem(
            ShopCubit.get(context).favoritesModel!.data!.data![index].product!,
            context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.favorite,
              color: Colors.grey,
              size: 100.0,
            ),
            Text(
              'Favorites Is Empty, Please Add Some Favorites Products',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );

Widget buildCatItem(DataModel model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image(
            image: CachedNetworkImageProvider(model.image!),
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            model.name!,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
          ),
        ],
      ),
    );

Widget buildLoading() => const CircularProgressIndicator();

Widget buildCartItem(CartsData model, context) => Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CachedNetworkImage(
                  imageUrl: model.product!.image!,
                  width: 110.0,
                  height: 110.0,
                  placeholder: (context, url) => Stack(
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
                  // fit: BoxFit.cover,
                ),
                if (model.product!.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.product!.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.product!.price.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.product!.discount != 0)
                        Text(
                          model.product!.oldPrice.toString(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Spacer(),
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Expanded(
                                      child: AlertDialog(
                                        title: const Text('Remove from cart'),
                                        content: const Text(
                                            'Do you really want to remove this item from cart?'),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              height: 50,
                                              child: OutlinedButton(
                                                onPressed: ShopCubit.get(
                                                                context)
                                                            .favorites[
                                                        model.product!.id]!
                                                    ? null
                                                    : () {
                                                        ShopCubit.get(context)
                                                            .changeFavorites(
                                                                model.product!
                                                                    .id!);
                                                        ShopCubit.get(context)
                                                            .changeCarts(model
                                                                .product!.id!);
                                                        Navigator.pop(context);
                                                      },
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.orange,
                                                        size: 20.0,
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(
                                                        'SAVE FOR LATER',
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              height: 50,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  ShopCubit.get(context)
                                                      .changeCarts(
                                                          model.product!.id!);
                                                  Navigator.pop(context);
                                                },
                                                elevation: 10,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.delete_outlined,
                                                      color: Colors.white,
                                                      size: 20.0,
                                                    ),
                                                    SizedBox(
                                                      width: 1,
                                                    ),
                                                    Text(
                                                      'REMOVE ITEM',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.delete_outlined,
                                    color: Colors.orange,
                                    size: 20.0,
                                  ),
                                  Text(
                                    'REMOVE',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: FloatingActionButton(
                                elevation: 0,
                                onPressed: () {
                                  ShopCubit.get(context).minusQuantity();
                                },
                                backgroundColor: Colors.orange,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${ShopCubit.get(context).quantity}',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: FloatingActionButton(
                                elevation: 0,
                                onPressed: () {
                                  ShopCubit.get(context).plusQuantity();
                                },
                                backgroundColor: Colors.orange,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
