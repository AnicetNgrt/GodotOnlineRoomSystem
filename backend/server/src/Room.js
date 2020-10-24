/**
 * Copyright 2020 Anicet Nougaret & contributors
 * See LICENCE.txt
 */

const englishWordGen = require('./wordGen')
const messages = require('./messages')

class Room {
    id = englishWordGen()[0];
    users = [];
    maxUsers = 1024;
    started = false;

    constructor() {}

    sendDataToEveryone(data) {
        this.users.forEach(u => u.sendData(data))
    }

    join(user) {
        if(this.users.length >= this.maxUsers) return false
        user.sendData(messages.JOINED_ROOM(this.id, this.getUsersND()))
        this.users.push(user)
        this.sendDataToEveryone(messages.USER_JOINED(this.id, this.getUserND(user)))
        return true
    }

    onUserLeft(user) {
        this.sendDataToEveryone(messages.USER_LEFT(this.id, user.id))
    }

    onStart() {
        this.started = true
        this.sendDataToEveryone(messages.GAME_STARTED(this.id))
    }

    onDeleted() {
        this.sendDataToEveryone(messages.ROOM_DELETED(this.id))
        this.users.forEach(u => delete u.rooms[this.id])
    }

    getUsersND() {
        return this.users.map(u => this.getUserND(u))
    }

    getUserND(user) {
        return user.toNetworkData()
    }
}

module.exports = Room