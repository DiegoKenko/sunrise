const int chatMessageLimit = 15;

const stripePublicKeyLive =
    'pk_live_51MjQvYJ4mdsV96FNax0KIq2c8UVyYIlGTZ1iI2EN8JiNBRldyRD4WDJTqfqWhzPikRL2U6w0QQq5ju4Hfy1Nlnda00Yle3aGEg';
const stripeSecretKeyLive = String.fromEnvironment('STRIPE_SECRET_KEY');
const stripePublicKeyTest =
    'pk_test_51MjQvYJ4mdsV96FN5HNtLuIJSINqlcym3C5voqslR2bACLQ6lFV4czMPuGPxyZAbqgvwhJcrY8guPObs8znIQDbe00C3WY2L9U';
const stripePaymentIntentEndpoint =
    'https://us-central1-sunrise-a2153.cloudfunctions.net/stripePaymentIntentRequest';
