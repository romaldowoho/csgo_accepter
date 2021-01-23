const Koa = require('koa');
const shell = require('shelljs');
const ngrok = require('ngrok');
const TelegramBot = require('node-telegram-bot-api');
const bodyParser = require("koa-body");

const app = new Koa();

app.use(bodyParser({
   multipart: true,
   urlencoded: true
}));

const PORT = 3000;
const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
const CHAT_ID = process.env.TELEGRAM_CHAT_ID;
let x, y; // coordinates of the accept img
let request_received = false; // to make sure the "found image" request is processed only once

const bot = new TelegramBot(BOT_TOKEN, {polling: true});
bot.on('message', (msg) => {
	if (msg.text === "1") {
		shell.exec(`CLICKER.ahk ${x} ${y}`); 
	}
});

app.use(async ctx => {
	console.log("Got request");
	if (ctx.request.url === "/favicon.ico") return;

	let coords = ctx.request.header.cookie;
	if (coords && !request_received) {
		let xy = coords.split(',');
		x = +xy[0] + 20; // 20 pixels offset to click
		y = +xy[1] + 20;
		bot.sendMessage(CHAT_ID, "GAME FOUND. Reply 1 to accept");
		request_received = true;
	}
	ctx.body = "Ok";
	ctx.status = 200;
	return;
});

app.listen(PORT, async () => {
	console.log("Listening on port " + PORT);
	shell.exec("FIND_IMAGE.ahk", {async: true});
});