const admin = require("firebase-admin");

const serviceAccount = require('./service-account-key.json'); // Replace with actual path

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://flutter-dating-app-f3f66.firebaseio.com' // Replace with your project's URL
});

const firestore = admin.firestore();

module.exports = { firestore };
