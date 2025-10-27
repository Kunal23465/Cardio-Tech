import 'package:cardio_tech/src/data/models/New_order/order_priority.dart';
import 'package:cardio_tech/src/data/service/new_order/order_priority.dart';

class OrderPriorityRepository {
  final OrderPriorityService _service = OrderPriorityService();
  Future<List<OrderPriority>> fetchAll() async {
    final resp = await _service.getAllPriority();

    if (resp.statusCode == 200 && resp.data != null) {
      final list = resp.data['data'] as List<dynamic>;
      return list
          .map((e) => OrderPriority.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch order priorities: ${resp.statusCode}");
    }
  }
}
