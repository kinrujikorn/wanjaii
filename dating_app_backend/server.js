const express = require('express');
const { firestore } = require('./firebase-admin'); // Import Firestore instance

const app = express();
const port = 3000; // Customize port number if needed

// Example endpoint to add user data (replace with your data structure)
app.post('/users', async (req, res) => {
  const { email } = req.body;

  try {
    // Create a new user document in Firestore with the provided email
    const userRef = await firestore.collection('users').add({
      email: email,
    });
    res.status(201).json({ message: 'User created successfully', userId: userRef.id });
  } catch (error) {
    console.error('Error adding user:', error);
    res.status(500).json({ message: 'Error adding user' });
  }
});

app.put('/users/:uid/like/:likedUserId', async (req, res) => {
  const { uid, likedUserId  } = req.params;

  try {
    const userRef = firestore.collection('users').doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Add likedUserId to likedUsers array if not already present
    const userData = userDoc.data();
    const likedUsers = userData.likedUsers || [];
    if (!likedUsers.includes(likedUserId )) {
      likedUsers.push(likedUserId );
      await userRef.update({ likedUsers });
    }

    res.status(200).json({ message: 'Liked user updated successfully' });
  } catch (error) {
    console.error('Error updating liked user:', error);
    res.status(500).json({ error: 'Failed to update liked user' });
  }
});

app.get('/users', async (req, res) => {
  try {
    const usersRef = firestore.collection('users');
    const usersSnapshot = await usersRef.get();
    const users = usersSnapshot.docs.map((doc) => ({
      uid: doc.id,
     ...doc.data(),
    }));
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

app.get('/users/:uid', async (req, res) => {
  const { uid } = req.params;
  //console.log("UID:", uid);
  try {
    const userDoc = await firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      const userData = userDoc.data();
      res.json(userData);
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch user' });
  }
});

app.get('/matches', async (req, res) => {
  try {
    const matchesSnapshot = await firestore.collection('matches').get();
    const matches = matchesSnapshot.docs.map((doc) => ({
      matchId: doc.id,
      ...doc.data(),
    }));
    res.json(matches);
  } catch (error) {
    console.error('Error fetching matches:', error);
    res.status(500).json({ error: 'Failed to fetch matches' });
  }
});

app.get('/users/:uid/matches', async (req, res) => {
  const { uid } = req.params;

  try {
    const query1 = await firestore.collection('matches').where('user1', '==', uid).get();
    const query2 = await firestore.collection('matches').where('user2', '==', uid).get();

    const matches = [...query1.docs, ...query2.docs].map((doc) => {
      const data = doc.data();
      const matchedUserId = data.user1 === uid ? data.user2 : data.user1;
      return matchedUserId;
    });

    const matchedUsers = await Promise.all(
      matches.map(async (matchedUserId) => {
        const userDoc = await firestore.collection('users').doc(matchedUserId).get();
        return userDoc.exists ? userDoc.data() : null;
      })
    );

    res.json(matchedUsers.filter((user) => user !== null));
  } catch (error) {
    console.error('Error fetching matched users:', error);
    res.status(500).json({ error: 'Failed to fetch matched users' });
  }
});

/* app.get("/users/filters", async (req, res) => {
  const { age, gender, location, sortBy } = req.query;
  try {
    let usersRef = firestore.collection("users");

    // Applying filters if provided
    if (age) {
      usersRef = usersRef.where("age", "==", parseInt(age));
    }
    if (gender) {
      usersRef = usersRef.where("gender", "==", gender);
    }
    if (location) {
      usersRef = usersRef.where("location", "==", location);
    }

    // Sorting if sortBy is provided
    if (sortBy) {
      usersRef = usersRef.orderBy(sortBy);
    }

    const usersSnapshot = await usersRef.get();
    const users = usersSnapshot.docs.map((doc) => ({
      uid: doc.id,
      ...doc.data(),
    }));
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch users" });
  }
}); */

app.get('/users/filter', async (req, res) => {
  const { interestedIn, location, minAge, maxAge } = req.headers;
  try {
    const usersRef = firestore.collection('users');
    const usersSnapshot = await usersRef.get();
    const filteredUsers = usersSnapshot.docs.filter((userDoc) => {
      const userData = userDoc.data();
      return (
        (interestedIn === '0' && userData.gender === 'female') ||
        (interestedIn === '1' && userData.gender === 'male') ||
        (interestedIn === '2' && (userData.gender === 'female' || userData.gender === 'male')) &&
        (location === '' || userData.location === location) &&
        (userData.age >= minAge && userData.age <= maxAge)
      );
    });
    const filteredUsersJson = filteredUsers.map((userDoc) => userDoc.data());
    res.json(filteredUsersJson);
  } catch (error) {
    console.error('Error fetching filtered users:', error);
    res.status(500).json({ error: 'Failed to fetch filtered users' });
  }
});




app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});