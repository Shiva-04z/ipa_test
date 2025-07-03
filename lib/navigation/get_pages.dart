import 'package:apple_grower/features/bilty_page/bilty_page_bindings.dart';
import 'package:apple_grower/features/bilty_page/bilty_page_view.dart';
import 'package:apple_grower/features/bilty_page_aadhti/bilty_page_aadhti_bindings.dart';
import 'package:apple_grower/features/bilty_page_aadhti/bilty_page_aadhti_view.dart';
import 'package:apple_grower/features/forms/consignmentForm/consignment_form_bindings.dart';
import 'package:apple_grower/features/forms/consignmentForm/consignment_form_page.dart';
import 'package:apple_grower/features/profile_page/profile_page_bindings.dart';
import 'package:apple_grower/features/profile_page/profile_page_view.dart';
import 'package:apple_grower/features/signUpPage/signUP_binidng.dart';
import 'package:apple_grower/features/signUpPage/signUp_view.dart';
import 'package:apple_grower/features/register/register_binding.dart';
import 'package:apple_grower/features/register/register_view.dart';
import 'package:apple_grower/features/splash_screen/splash_screen_bindings.dart';
import 'package:apple_grower/features/splash_screen/splash_screen_view.dart';
import 'package:apple_grower/features/grower/grower_binding.dart';
import 'package:apple_grower/features/grower/grower_view.dart';
import 'package:apple_grower/features/packHouse/packHouse_binding.dart';
import 'package:apple_grower/features/packHouse/packHouse_view.dart';
import 'package:apple_grower/features/aadhati/aadhati_binding.dart';
import 'package:apple_grower/features/aadhati/aadhati_view.dart';
import 'package:apple_grower/features/ladaniBuyers/ladaniBuyers_binding.dart';
import 'package:apple_grower/features/ladaniBuyers/ladaniBuyers_view.dart';
import 'package:apple_grower/features/freightForwarder/freightForwarder_binding.dart';
import 'package:apple_grower/features/freightForwarder/freightForwarder_view.dart';
import 'package:apple_grower/features/driver/driver_binding.dart';
import 'package:apple_grower/features/driver/driver_view.dart';
import 'package:apple_grower/features/transportUnion/transportUnion_binding.dart';
import 'package:apple_grower/features/transportUnion/transportUnion_view.dart';
import 'package:apple_grower/features/ampcOffice/ampcOffice_binding.dart';
import 'package:apple_grower/features/ampcOffice/ampcOffice_view.dart';
import 'package:apple_grower/features/hpPolice/hpPolice_binding.dart';
import 'package:apple_grower/features/hpPolice/hpPolice_view.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_binding.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_view.dart';
import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:get/get.dart';

List<GetPage> getPages = [
  GetPage(
    name: RoutesConstant.splash,
    page: () => SplashScreenView(),
    binding: SplashScreenBindings(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.signUp,
    page: () => SignUpView(),
    binding: SignUpBindings(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.register,
    page: () => RegisterView(),
    binding: RegisterBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.grower,
    page: () => GrowerView(),
    binding: GrowerBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.packHouse,
    page: () => PackHouseView(),
    binding: PackHouseBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.aadhati,
    page: () => AadhatiView(),
    binding: AadhatiBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.ladaniBuyers,
    page: () => LadaniBuyersView(),
    binding: LadaniBuyersBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.freightForwarder,
    page: () => FreightForwarderView(),
    binding: FreightForwarderBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.driver,
    page: () => DriverView(),
    binding: DriverBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.transportUnion,
    page: () => TransportUnionView(),
    binding: TransportUnionBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.apmcOffice,
    page: () => ApmcOfficeView(),
    binding: ApmcOfficeBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.hpPolice,
    page: () => HpPoliceView(),
    binding: HpPoliceBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.hpAgriBoard,
    page: () => HPAgriBoardView(),
    binding: HPAgriBoardBinding(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.profile,
    page: () => ProfilePageView(),
    binding: ProfilePageBindigs(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.consignmentForm,
    page: () => ConsignmentFormPage(),
    binding: ConsignmentBindings(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.biltyCreation,
    page: () => BiltyPageView(),
    binding: BiltyPageBindings(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.biltyCreationAadhati,
    page: () => BiltyPageAadhtiView(),
    binding: BiltyPageAadhtiBindings(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
  GetPage(
    name: RoutesConstant.forward,
    page: () => BiltyPageAadhtiView(),
    binding: BiltyPageAadhtiBindings(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),GetPage(
    name: RoutesConstant.bidding,
    page: () => BiltyPageAadhtiView(),
    binding: BiltyPageAadhtiBindings(),
    transition: Transition.fadeIn,
    transitionDuration: Duration(microseconds: 300),
  ),
];
