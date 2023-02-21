import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/layout/shop_app/shop_layout.dart';
import 'package:flutter_udemy_shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:flutter_udemy_shop_app/modules/shop_login/shop_login_screen.dart';
import 'package:flutter_udemy_shop_app/shared/bloc_observer.dart';
import 'package:flutter_udemy_shop_app/shared/components/constants.dart';
import 'package:flutter_udemy_shop_app/shared/cubit/cubit.dart';
import 'package:flutter_udemy_shop_app/shared/network/local/cache_helper.dart';
import 'package:flutter_udemy_shop_app/shared/network/remote/dio_helper.dart';
import 'package:flutter_udemy_shop_app/shared/styles/Themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;

  // bool? isDark = CacheHelper.getBoolean(key: 'isDark');
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  // late final bool onBoarding;
  // late final bool isDark;

  const MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;
  // MyApp({
  //   this.onBoarding,
  // });
  @override
  Widget build(BuildContext context) {
    // for disabling auto rotate
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData()
            ..getCarts()
            ..getDetails(),
        ),
      ],
      child: MaterialApp(
        // دى بانر كلمه ديباج الى ع يمين من فوق
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // darkTheme: darkTheme,
        home: startWidget,
        // home: onBoarding ? ShopLoginScreen() : OnBoardingScreen(),
        // false kda hyrg3 3la onBoarding screen tany
        //  home: false ? ShopLoginScreen() : OnBoardingScreen(),
      ),
    );
  }
}
