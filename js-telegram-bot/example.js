var TelegramBot = require('node-telegram-bot-api');

var token = 'TELEGRAM_TOKEN';

var bot = new TelegramBot(token, { polling: true });

bot.onText(/\/ping/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = "I'm here :)...";

  bot.sendMessage(chatId, resp);
});

bot.onText(/\/chatid/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = chatId;

  bot.sendMessage(chatId, resp);
});

bot.onText(/\/whats_up/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = "Not much";

  bot.sendMessage(chatId, resp);
});

bot.onText(/\/random_message/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = ["worked","yup","great","oki doki"];
  valueToUse = resp[Math.floor(Math.random() * resp.length)];

  bot.sendMessage(chatId, valueToUse);
});

bot.onText(/\/repeat_this (.+)/, function (msg, match) {

  var chatId = msg.chat.id;
  var resp = match[1];

  bot.sendMessage(chatId, resp);
});
