import 'package:flutter/material.dart';
import 'package:sunrise/constants/enum/enum_payment_options.dart';
import 'package:sunrise/constants/icons.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/controllers/payment/payment_screen_controller.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        height: 350,
        padding: EdgeInsets.only(bottom: 20),
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
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 35,
                  color: kPrimaryColor,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: paymentScreenController
                                      .isPaymentSelected(index),
                                  onChanged: (value) {
                                    paymentScreenController
                                        .paymentOptionsNotifier.value = index;
                                  },
                                ),
                                sunIcon,
                                Text(
                                  paymentScreenController
                                      .paymentOptions[index].description,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'R\$ ' +
                                    paymentScreenController
                                        .paymentOptions[index].priceFormatted,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: ((context, index) => Container(
                            height: 10,
                          )),
                      itemCount: paymentScreenController.paymentOptions.length,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(side: BorderSide.none),
                  ),
                  onPressed: () async {
                    await paymentScreenController
                        .purchase(getIt<AuthController>().lover.id);
                  },
                  child: Container(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'COMPRAR ',
                          style: TextStyle(
                            color: k2LevelColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sunIcon,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
