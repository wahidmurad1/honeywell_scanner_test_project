import 'package:get/get.dart';
import 'package:honeywell_test/controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HoneyController>(HoneyController());
  }
}