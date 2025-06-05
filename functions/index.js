const functions = require("firebase-functions");

exports.phonepeCallback = functions.region('us-central1').https.onRequest((req, res) => {
  console.log("PhonePe callback received:", req.body);
  res.set('Content-Type', 'application/json');
  res.status(200).send({ message: "Callback received successfully" });

});
