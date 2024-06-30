const express = require('express');
const app = express();
const usersRouter = require('./routes/users');
const chatsRouter = require('./routes/chats');
const firebase = require('./utils/firebase');

app.use(express.json());

app.use('/api/users', usersRouter);
app.use('/api/chats', chatsRouter);

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});