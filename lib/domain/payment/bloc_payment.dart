import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sunrise/constants/enum.dart';

class PaymentState extends Equatable {
  final PaymentStatus status;
  final CardFieldInputDetails? card;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.card = const CardFieldInputDetails(complete: false),
  });

  PaymentState copyWith({
    PaymentStatus? status,
    CardFieldInputDetails? card,
  }) {
    return PaymentState(
      status: status ?? this.status,
      card: card ?? this.card,
    );
  }

  @override
  List<Object?> get props => [status, card];
}

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentStartEvent extends PaymentEvent {}

class PaymentCreateIntentEvent extends PaymentEvent {
  final BillingDetails details;
  final EnumPaymentMethod paymentMethod;
  final List<Map<String, dynamic>> itens;

  const PaymentCreateIntentEvent({
    required this.details,
    required this.itens,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [details, itens];
}

class PaymentConfirmIntentEvent extends PaymentEvent {
  final String clientSecret;

  const PaymentConfirmIntentEvent({
    required this.clientSecret,
  });

  @override
  List<Object?> get props => [clientSecret];
}

class BlocPayment extends Bloc<PaymentEvent, PaymentState> {
  BlocPayment() : super(const PaymentState()) {
    on<PaymentStartEvent>(_onPaymentStart);

    on<PaymentCreateIntentEvent>(_onPaymentCreateIntent);

    on<PaymentConfirmIntentEvent>(_onPaymentConfirmIntent);
  }

  FutureOr<void> _onPaymentStart(event, emit) {
    emit(state.copyWith(status: PaymentStatus.initial));
  }

  FutureOr<void> _onPaymentCreateIntent(
    PaymentCreateIntentEvent event,
    emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    final paymentIntent = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: event.details),
      ),
    );
    final paymentIntentResults = await _callPayEndpointMethodId(
      useStripeSdk: true,
      paymentMethodId: paymentIntent.id,
      currency: 'usd',
      itens: event.itens,
    );

    if (paymentIntentResults['error'] != null) {
      emit(state.copyWith(status: PaymentStatus.failure));
    } else {
      if (paymentIntentResults['clientSecret'] != null) {
        if (paymentIntentResults['requiresAction'] == true) {
          final String clientSecret = paymentIntentResults['clientSecret'];
          add(PaymentConfirmIntentEvent(clientSecret: clientSecret));
        } else {
          emit(state.copyWith(status: PaymentStatus.success));
        }
      }
    }
  }

  FutureOr<void> _onPaymentConfirmIntent(
    PaymentConfirmIntentEvent event,
    emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    try {
      final paymentIntent =
          await Stripe.instance.handleNextAction(event.clientSecret);
      if (paymentIntent.status == PaymentIntentsStatus.RequiresAction) {
        Map<String, dynamic> results =
            await callPayEndpointIntentId(paymentIntentId: paymentIntent.id);
        if (results['error'] != null) {
          emit(state.copyWith(status: PaymentStatus.failure));
        } else {
          emit(state.copyWith(status: PaymentStatus.success));
        }
      }
      emit(state.copyWith(status: PaymentStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PaymentStatus.failure));
    }
  }

  Future<Map<String, dynamic>> callPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse(
      'https://us-central1-sunrise-a2153.cloudfunctions.net/stripePayEndPointIntentId',
    );
    var resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'paymentIntentId': paymentIntentId,
      }),
    );
    return json.decode(resp.body);
  }

  Future<Map<String, dynamic>> _callPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    required List<Map<String, dynamic>> itens,
  }) async {
    final url = Uri.parse(
      'https://us-central1-sunrise-a2153.cloudfunctions.net/stripePayEndPointMethodId',
    );
    var resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'itens': itens,
      }),
    );
    return json.decode(resp.body);
  }
}
