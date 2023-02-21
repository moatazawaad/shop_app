import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/categories_model.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/home_model.dart';
import 'package:flutter_udemy_shop_app/modules/product_details/details_product_screen.dart';
import 'package:flutter_udemy_shop_app/shared/components/components.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/cubit.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/states.dart';
import '../../refresh.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen(
      {Key? key,
      this.productId,
      this.productImage,
      this.prodName,
      this.prodPrice,
      this.prodOldPrice,
      this.prodImages,
      this.prodDesc})
      : super(key: key);

  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  var productId;
  var productImage;
  var prodName;
  var prodPrice;
  var prodOldPrice;
  var prodImages;
  var prodDesc;

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
        return RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: () async {
            ShopCubit.get(context).getHomeData();
          },
          child: ConditionalBuilder(
              condition: ShopCubit.get(context).homeModel != null &&
                  ShopCubit.get(context).categoriesModel != null,
              builder: (context) => productsBuilder(
                  ShopCubit.get(context).homeModel!,
                  ShopCubit.get(context).categoriesModel!,
                  context),
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
                  )),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoriesModel categoryModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: e.image!,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => buildCategoryItem(
                        categoryModel.data!.data[index],
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoryModel.data!.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                // first is width / second is height
                childAspectRatio: 1 / 1.69,
                children: List.generate(
                  model.data!.products.length,
                  (index) => buildGridProducts(
                    model.data!.products[index],
                    context,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CachedNetworkImage(
            imageUrl: model.image!,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
            // progressIndicatorBuilder: (context, url, downloadProgress),
            // errorWidget: ,
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
          ),
          Container(
            color: Colors.black.withOpacity(
              .6,
            ),
            width: 100.0,
            child: Text(
              model.name!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  Widget buildGridProducts(ProductModel model, context) => InkWell(
        onTap: () {
          navigateTo(
            context,
            DetailsScreen(
              productId: model.id,
              prodName: model.name,
              prodPrice: model.price,
              prodOldPrice: model.oldPrice,
              productImage: model.image,
              prodImages: model.images,
              prodDesc: model.description,
            ),
          );
        },
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  CachedNetworkImage(
                    imageUrl: model.image!,
                    width: double.infinity,
                    height: 200,
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
                  if (model.discount != 0)
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
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.price.round()}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0)
                          Text(
                            '${model.oldPrice.round()}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.zero,
                          // width: 120,
                          height: 30,
                          decoration: BoxDecoration(
                            color: ShopCubit.get(context).carts[model.id]!
                                ? Colors.orange
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              ShopCubit.get(context).changeCarts(model.id!);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  ShopCubit.get(context).carts[model.id]!
                                      ? Icons.done
                                      : Icons.shopping_cart_checkout,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  ShopCubit.get(context).carts[model.id]!
                                      ? 'In your Cart'
                                      : 'Add to Cart',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
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
                          // iconSize: 20.0,
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
}
