/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.searchUsers = functions.https.onCall(async (data, context) => {
  const {text, option} = data;

  // Check if the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "The user is not authenticated.");
  }

  // Set the user ID to be used in the Firestore rules
  // eslint-disable-next-line no-unused-vars
  const userId = context.auth.uid;

  let query;
  switch (option) {
    case "all":
      query = admin.firestore().
          collection("users").
          where("keywords", "array-contains", text);
      break;
    case "occupations":
      query = admin.firestore().
          collection("users").
          where("occupation", ">=", text).
          where("occupation", "<", text + "z");
      break;
    case "people":
      query = admin.firestore().
          collection("users").
          where("name", ">=", text).
          where("name", "<", text + "z").
          where("occupation", "==", "person");
      break;
    case "interests":
      query = admin.firestore().collection("users").where("interests", "array-contains", text);
      break;
  }

  try {
    const snapshot = await query.get();
    const results = snapshot.docs.map((doc) => {
      const data = doc.data();
      const id = doc.id;
      return {id, ...data};
    });

    return results;
  } catch (error) {
    console.error(error);
    throw new functions.https.HttpsError("internal", "An error occurred while searching for users.");
  }
});
