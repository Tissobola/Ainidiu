const functions = require('firebase-functions');
console.log("a");



exports.myFunction = functions.firestore
  .collection('not')
  .document('1')
  .onUpdate((change, context) => {console.log("test")});

  exports.myFunctio = functions.firestore
  .collection('not')
  .document('1')
  .onCreate((change, context) => {console.log("test")});

  exports.myFuncti = functions.firestore
  .collection('not')
  .document('1')
  .onDelete((change, context) => {console.log("test")});

  exports.myFunct = functions.firestore
  .collection('not')
  .document('1')
  .onWrite((change, context) => {console.log("test")});