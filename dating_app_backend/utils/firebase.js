const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

const firestore = admin.firestore();

// Get user data
const getUserData = async (userId) => {
  return await firestore.collection('users').doc(userId).get();
};

// Get user chats
const getUserChats = async (userId) => {
  const chatsQuery = await firestore
    .collection('chats')
    .where('userIds', 'array-contains', userId)
    .get();

  const chats = chatsQuery.docs.map((doc) => doc.data());
  return chats;
};

// Get chat messages
const getChatMessages = async (chatId) => {
  const messagesQuery = await firestore
    .collection('chats')
    .doc(chatId)
    .collection('messages')
    .orderBy('timestamp', 'desc')
    .get();

  const messages = messagesQuery.docs.map((doc) => doc.data());
  return messages;
};

// Send a new message
const sendMessage = async (chatId, senderId, text) => {
  const message = {
    senderId,
    text,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  };

  await firestore
    .collection('chats')
    .doc(chatId)
    .collection('messages')
    .add(message);
};

module.exports = {
  getUserData,
  getUserChats,
  getChatMessages,
  sendMessage,
};