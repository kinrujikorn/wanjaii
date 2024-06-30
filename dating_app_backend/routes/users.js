const express = require('express');
const router = express.Router();
const firebase = require('../utils/firebase');

// Get user data
router.get('/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const userDoc = await firebase.getUserData(userId);
    res.json(userDoc.data());
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;