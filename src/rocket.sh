#!/usr/bin/env bash

URL_LOGIN="/api/v1/login"
SEND_MESSAGE_URL="/api/v1/chat.postMessage"

rocket::sendGroupMessage(){
	msg="$2"
  	ROCKET_CHAT_HOOK="$1"
	data="{\"text\":\"${msg}\",\"username\": \"${BOT_NAME}\",\"avatar\":\"${BOT_AVATAR}\"}"
	curl -H "Content-type:application/json" "${ROCKET_CHAT_URL}/hooks/{$ROCKET_CHAT_HOOK}" -d "$data"
}
