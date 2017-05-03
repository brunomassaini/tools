var TelegramBot = require('node-telegram-bot-api');

var token = 'TELEGRAM_TOKEN';

var bot = new TelegramBot(token, { polling: true });

// Answers to ping :)
bot.onText(/\/ping/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = "I'm here :)...";

  bot.sendMessage(chatId, resp);
});

// Bot answers with Telegram chat ID
bot.onText(/\/chatid/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = chatId;

  bot.sendMessage(chatId, resp);
});

// Bot gives specific answer
bot.onText(/\/whats_up/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = "Not much";

  bot.sendMessage(chatId, resp);
});

// Bot will respond randomly
bot.onText(/\/random_message/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = ["worked","yup","great","oki doki"];
  valueToUse = resp[Math.floor(Math.random() * resp.length)];

  bot.sendMessage(chatId, valueToUse);
});

// Bot will repeat message
bot.onText(/\/repeat_this (.+)/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = match[1];

  bot.sendMessage(chatId, resp);
});
