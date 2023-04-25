const functions = require("firebase-functions");
const stripe = require("stripe")(functions.config().stripe.testkey);
const onGereateResponse = function (intent) {
    switch (intent.status) {
        case "requires_action":
            return {
                clientSecret: intent.client_secret,
                requies_action: true,
                status: intent.status,
            }
        case "requires_payment_method":
            return {
                "error": "No payment method provided",
            }
        case "succeeded":
            return { clientSecret: intent.client_secret, status: intent.status, }
    }
    return { "error": "Unknown error" }
}

const calculateOrderAmount = (itens) => {
    prices = [];
    catalog = [
        { 'id': '1', 'price': 100 },
        { 'id': '2', 'price': 200 },
    ];

    itens.forEach(item => {
        const product = catalog.find(p => p.id === item.id);
        prices.push(product.price);
    });
    return parseInt(prices.reduce((a, b) => a + b, 0));
}


exports.stripePayEndPointMethodId = functions.https.onRequest(async (req, res) => {
    const { paymentMethodId, itens, currency, usseStripeS } = req.body;
    const orderAmount = calculateOrderAmount(itens);
    try {
        if (paymentMethodId) {
            const params = {
                amount: orderAmount,
                currency: currency,
                payment_method: paymentMethodId,
                confirmation_method: "manual",
                confirm: true
            }
            const paymentIntent = await stripe.paymentIntents.create(params);
            res.send({
                clientSecret: paymentIntent.client_secret
            });

        }
        res.sendStatus(400);
    } catch (error) {
        return res.status(500).send({ error: error.message });
    }
});

exports.stripePayEndPointIntentId = functions.https.onRequest(async (req, res) => {
    const { paymentIntentId } = req.body;
    try {
        if (paymentIntentId) {
            const intent = await stripe.paymentIntents.confirm(paymentIntentId);
            return res.send(onGereateResponse(intent));
        }

    } catch (error) {
        return res.status(500).send({ error: error.message });
    }
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
