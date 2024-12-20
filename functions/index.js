const functions = require("firebase-functions");
const admin = require("firebase-admin");
const request = require("graphql-request");

admin.initializeApp(functions.config().firebase);

const client = new request.GraphQLClient("https://rich-donkey-60.hasura.app/v1/graphql", {
    headers: {
        "content-type": "application/json",
        "x-hasura-admin-secret": "T0ydH2aUZRq5kiIIUXg8vFZJwUFZ4z131p7rSKOyxVXYnYSUiHVJM56rX7vabH5v"
    }
})

exports.registerUser = functions.https.onCall(async (data) => {
    const email = data.email;
    const password = data.password;
    const displayName = data.displayName;

    if (email == null || password == null || displayName == null) {
        throw new functions.https.HttpsError('register-failed', 'missing information');
    }

    try {
        var userRecord = await admin.auth().createUser({
            email: email,
            password: password,
            displayName: displayName
        });

        const customClaims = {
            "https://hasura.io/jwt/claims": {
                "x-hasura-default-role": "user",
                "x-hasura-allowed-roles": ["user"],
                "x-hasura-user-id": userRecord.uid
            }
        };

        await admin.auth().setCustomUserClaims(userRecord.uid, customClaims);

        return userRecord.toJSON();

    } catch (error) {
        console.error('Error processing register:', error);
        throw new functions.https.HttpsError('internal', 'Error processing register.');
    }
});

exports.processSignUp = functions.auth.user().onCreate(async (user) => {
    const id = user.uid;
    const email = user.email;
    const name = user.displayName || "No Name";

    if (id == null || email == null || name == null) {
        throw new functions.https.HttpsError('sync-failed', 'missing information');
    }

    const mutation = `mutation($id: String!, $email: String, $name: String) {
        insert_user(objects: [{
            id: $id,
            email: $email,
            name: $name,
          }]) {
            affected_rows
          }
        }`;

    try {
        const data = await client.request(mutation, {
            id: id,
            email: email,
            name: name
        })

        return data;

    } catch (error) {
        console.error('Error processing sign up:', error);
        throw new functions.https.HttpsError('internal', 'Error processing sign up.');
    }

});

exports.processDelete = functions.auth.user().onDelete(async (user) => {
    const mutation = `mutation($id: String!) {
        delete_user(where: {id: {_eq: $id}}) {
          affected_rows
        }
    }`;

    const id = user.uid;

    try {
        const data = await client.request(mutation, {
            id: id,
        })
        return data;
    } catch (error) {
        console.error('Error processing delete:', error);
        throw new functions.https.HttpsError('internal', 'Error processing delete.');
    }
});

exports.updateUserName = functions.https.onCall(async (data) => {
    const id = data.id;
    const name = data.name;

    if (id == null || name == null) {
        throw new functions.https.HttpsError('update-failed', 'missing information');
    }

    const mutation = `mutation($id: String!, $name: String!) {
        update_user(where: {id: {_eq: $id}}, _set: {name: $name}) {
          affected_rows
        }
      }`;

    try {
        const data = await client.request(mutation, {
            id: id,
            name: name
        })
        return data;
    } catch (error) {
        console.error('Error processing update user name:', error);
        throw new functions.https.HttpsError('internal', 'Error processing user name.');
    }
});