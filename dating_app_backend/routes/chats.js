const express = require('express');
const router = express.Router();
const firebase = require('../utils/firebase');

// Get chats for a user
router.get('/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const chats = await firebase.getUserChats(userId);
    res.json(chats);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get messages for a chat
router.get('/:chatId/messages', async (req, res) => {
  try {
    const chatId = req.params.chatId;
    const messages = await firebase.getChatMessages(chatId);
    res.json(messages);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Send a new message
router.post('/:chatId/messages', async (req, res) => {
  try {
    const chatId = req.params.chatId;
    const { senderId, text } = req.body;
    await firebase.sendMessage(chatId, senderId, text);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;