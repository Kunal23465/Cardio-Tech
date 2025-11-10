import 'package:cardio_tech/src/provider/cardioLogistsProvider/cardioSubmitReportProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/getAllStatusProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/myOrderProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/orderStatusProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/downloadEkgReportProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/getOrderByIdProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/orderFilterProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/submitOrderDetailsProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/commons/allStatusProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/all_cardiologist_provider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/create_order_provider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/gender_provider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/order_priority_provider.dart';
import 'package:cardio_tech/src/provider/user/loggedInUserDetailsProvider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => CardiologistProvider()),
  ChangeNotifierProvider(create: (_) => OrderPriorityProvider()),
  ChangeNotifierProvider(create: (_) => GenderProvider()),
  ChangeNotifierProvider(create: (_) => CreateOrderProvider()),
  ChangeNotifierProvider(create: (_) => OrderFilterProvider()),
  ChangeNotifierProvider(create: (_) => AllStatusProvider()),
  ChangeNotifierProvider(create: (_) => GetOrderByIdProvider()),
  ChangeNotifierProvider(create: (_) => MyOrderProvider()),
  ChangeNotifierProvider(create: (_) => GetAllCardioStatusProvider()),
  ChangeNotifierProvider(create: (_) => OrderStatusProvider()),
  ChangeNotifierProvider(create: (_) => CardioSumbitReportProvider()),
  ChangeNotifierProvider(create: (_) => DownloadEkgReportProvider()),
  ChangeNotifierProvider(create: (_) => SubmitOrderDetailsProvider()),
  ChangeNotifierProvider(create: (_) => LoggedInUserDetailsProvider()),
];
