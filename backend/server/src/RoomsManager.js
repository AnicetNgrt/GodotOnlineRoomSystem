/**
 * Copyright 2020 Anicet Nougaret & contributors
 * See LICENCE.txt
 */

const Room = require('./Room')
const messages = require('./messages')

class RoomsManager {
    rooms = {}

    handleMessage(data, sender) {
        switch(data.message) {
            case 'create room':
                this.createRoom(sender)
                break;
            case 'join room':
                this.joinRoom(sender, data.gameId)
                break;
            case 'leave room':
                this.leaveRoom(sender, data.gameId)
                break;
            case 'start game':
                this.startGame(sender, data.gameId)
                break;
        }
    }
    
    joinRoom(user, roomId) {
        if(this.rooms[roomId]) {
            let room = this.rooms[roomId]
            let permitted = user.joinRoom(room)
            if(!permitted) {
                user.sendData(messages.FAILED_TO_JOIN_ROOM("access refused"))
            }
        } else {
            user.sendData(messages.FAILED_TO_JOIN_ROOM("wrong code"))
        }
    }

    leaveRoom(user, id) {
        if(this.rooms[id] && user.rooms[id]) {
            let room = user.rooms[id]
            room.onUserLeft(user)
            if(room.users.length <= 0) {
                this.removeRoom(room)
            }
        }
    }
    
    createRoom(host) {
        let room = new Room(host)
        this.rooms[room.id] = room
        let permitted = host.joinRoom(room)
        if(!permitted) this.removeRoom(room)
    }
    
    removeRoom(room) {
        room.onDeleted()
        delete this.rooms[room.id]
    }
    
    startGame(user, id) {
        if(this.rooms[id] && user.rooms[id]) {
            let room = user.rooms[id];
            room.onStart();
        }
    }
}

let singleton = new RoomsManager()

module.exports = singleton
