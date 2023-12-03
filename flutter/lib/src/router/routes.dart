import 'package:auto_route/auto_route.dart';
import 'package:riada/src/router/routes.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: "/OnBoarding",
      page: OnBoardingRoute.page,
    ),
  ];
}
