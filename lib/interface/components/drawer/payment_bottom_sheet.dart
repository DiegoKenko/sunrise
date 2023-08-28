import 'package:flutter/material.dart';
import 'package:sunrise/constants/enum/enum_payment_options.dart';
import 'package:sunrise/interface/controllers/payment/payment_screen_controller.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({super.key});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final PaymentScreenController paymentScreenController =
      PaymentScreenController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: Colors.white,
      ),
      child: ValueListenableBuilder(
        valueListenable: paymentScreenController.paymentOptionsNotifier,
        builder: (context, state, _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Checkbox(
                    value: paymentScreenController.isPaymentSelected(index),
                    onChanged: (value) {
                      paymentScreenController.paymentOptionsNotifier.value =
                          index;
                    },
                  ),
                  Text(paymentScreenController.paymentOptions[index].description),
                ],
              );
            },
            separatorBuilder: ((context, index) => Container(height: 10,)),
            itemCount: paymentScreenController.paymentOptions.length,
          );
        },
      ),
    );
  }
}
