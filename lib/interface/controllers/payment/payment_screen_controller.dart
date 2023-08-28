import 'package:flutter/foundation.dart';
import 'package:sunrise/constants/enum/enum_payment_options.dart';
import 'package:sunrise/interface/states/payment_state.dart';

class PaymentScreenController extends ValueNotifier<PaymentState> {
  PaymentScreenController() : super(InitialPaymentState());

  List<EnumPaymentOption> paymentOptions = EnumPaymentOption.values;
  ValueNotifier<int> paymentOptionsNotifier = ValueNotifier<int>(0);

  void changePaymentOption(EnumPaymentOption option) {
    paymentOptionsNotifier.value =
        paymentOptions.indexWhere((element) => element == option);
  }

  bool isPaymentSelected(int index) {
    return paymentOptionsNotifier.value == index;
  }
}
