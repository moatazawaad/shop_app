import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/models/shop_app/product_details_model.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen(
      {Key? key,
      this.productId,
      this.productImage,
      this.prodName,
      this.prodPrice,
      this.prodOldPrice,
      this.prodImages,
      this.prodDesc})
      : super(key: key);
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
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.orange,
              title: const Text(
                'Salla',
                style: TextStyle(
                    //  color: Colors.white,
                    ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_circle_outlined,
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: [1, 2, 3, 4, 5]
                        .map(
                          (e) => CachedNetworkImage(
                            imageUrl: prodImages,
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
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text(
                  //         'Categories',
                  //         style: TextStyle(
                  //           fontSize: 24.0,
                  //           fontWeight: FontWeight.w800,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 10.0,
                  //       ),
                  //       SizedBox(
                  //         height: 100.0,
                  //         child: ListView.separated(
                  //           scrollDirection: Axis.horizontal,
                  //           physics: const BouncingScrollPhysics(),
                  //           itemBuilder: (context, index) => buildCategoryItem(
                  //             categoryModel.data!.data[index],
                  //           ),
                  //           separatorBuilder: (context, index) => const SizedBox(
                  //             width: 10.0,
                  //           ),
                  //           itemCount: categoryModel.data!.data.length,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 20.0,
                  //       ),
                  //       const Text(
                  //         'New Products',
                  //         style: TextStyle(
                  //           fontSize: 24.0,
                  //           fontWeight: FontWeight.w800,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  // Container(
                  //   color: Colors.grey[300],
                  //   child: GridView.count(
                  //     shrinkWrap: true,
                  //     primary: false,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     crossAxisCount: 2,
                  //     crossAxisSpacing: 1.0,
                  //     mainAxisSpacing: 1.0,
                  //     // first is width / second is height
                  //     childAspectRatio: 1 / 1.69,
                  //     children: List.generate(
                  //       model.data!.products.length,
                  //           (index) => buildGridProducts(
                  //         model.data!.products[index],
                  //         context,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ));
      },
    );
  }

  Widget buildProductItem(DetailsData model, context,
          {bool isOldPrice = true}) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 120.0,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: CachedNetworkImageProvider(productImage),

                    width: 120.0,

                    height: 120.0,

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
                            // ShopCubit.get(context).changeFavorites(model.id!);
                          },

                          icon: const CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.favorite_border,
                            ),
                          ),

                          color: Colors.white,

                          iconSize: 14.0,
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
