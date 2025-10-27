import 'package:cardio_tech/src/provider/new_order/all_cardiologist_provider.dart';
import 'package:cardio_tech/src/provider/new_order/order_priority_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => CardiologistProvider()),
  ChangeNotifierProvider(create: (_) => OrderPriorityProvider()),
];
