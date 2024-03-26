# kbot
## Description

**kbot** is a Telegram bot. This bot is made with Golang using [Cobra CLI](https://github.com/spf13/cobra) and [Telebot.v3](gopkg.in/telebot.v3) frameworks.

Link: [t.me/andrulyan_bot](https://t.me/andrulyan_bot)

## Installation
1. Clone this repository.
```bash
git clone https://github.com/anderson28/kbot.git
```
2. Create a new telegram bot with [BotFather](t.me/BotFather) and get a TELE_TOKEN.
3. Assign the value of the received token to the TELE_TOKEN environment variable.
```bash
read -s TELE_TOKEN
export TELE_TOKEN
```
4. Build the project. 
```bash
go build -ldflags "-X=github.com/anderson28/cmd.appVersion=[appVersion]"
```
5. Run  using the "start" command.
```bash
./kbot start
```
## Usage
Enter **/start hello** in kbot and it will return "Hello I'm kbot [appVersion]".
