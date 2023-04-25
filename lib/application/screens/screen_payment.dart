import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sunrise/application/components/ou_divider.dart';
import 'package:sunrise/application/constants.dart';
import 'package:sunrise/application/styles.dart';
import 'package:sunrise/domain/payment/bloc_payment.dart';

class ScreenPayment extends StatefulWidget {
  const ScreenPayment({Key? key}) : super(key: key);
  @override
  State<ScreenPayment> createState() => _ScreenPaymentState();
}

class _ScreenPaymentState extends State<ScreenPayment> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<BlocPayment>(
        create: (context) => BlocPayment(),
        child: Scaffold(
          body: Container(
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: kBackgroundDecorationLight,
            child: BlocBuilder<BlocPayment, PaymentState>(
              builder: (context, state) {
                if (state.status == PaymentStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: const [
                      FormCreditCardSunrise(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: OuDivider(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FormCreditCardSunrise extends StatefulWidget {
  const FormCreditCardSunrise({Key? key}) : super(key: key);

  @override
  State<FormCreditCardSunrise> createState() => _FormCreditCardSunriseState();
}

class _FormCreditCardSunriseState extends State<FormCreditCardSunrise> {
  final CardEditController cardNumberController = CardEditController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreditCardWidget(
          cardNumber: cardNumberController.details.number.toString(),
          expiryDate:
              '${cardNumberController.details.expiryMonth}/${cardNumberController.details.expiryYear}',
          cardHolderName: '',
          cvvCode: cardNumberController.details.cvc.toString(),
          showBackView: false,
          onCreditCardWidgetChange: (p0) {},
        ),
        CardFormField(
          countryCode: 'BR',
        ),
        FilledButton(
          child: const Text('confirmar'),
          onPressed: () {
            (cardNumberController.details.complete)
                ? context.read<BlocPayment>().add(
                      const PaymentCreateIntentEvent(
                        paymentMethod: EnumPaymentMethod.card,
                        details: BillingDetails(name: 'John Doe'),
                        itens: [
                          {
                            'id': '1',
                            'price': 100,
                          }
                        ],
                      ),
                    )
                : debugPrint('not complete');
          },
        ),
      ],
    );
  }
}
