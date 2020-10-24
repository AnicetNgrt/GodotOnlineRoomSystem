/**
 * Copyright 2020 Anicet Nougaret & contributors
 * See LICENCE.txt
 */

const User = require('./User')
const messages = require('./messages')

class UsersManager {
    users = {}

    handleMessage(data, sender) {
        switch(data.message) {
            case 'my name is':
                this.changeName(sender, data.name)
                break;
        }
    }

    createUser(id, ws, name) {
        this.users[id] = new User(id, name, ws)
        this.users[id].sendData(messages.YOUR_ID(this.users[id].id, this.users[id].name))
        return this.users[id]
    }
    
    changeName(user, name) {
        if(name.length >= 4 && name.length <= 10)
            user.name = name
            user.sendData(messages.YOUR_ID(user.id, user.name))
    }
    
    removeUser(id) {
        this.users[id].onDeleted()
        delete this.users[id]
    }   
}

let singleton = new UsersManager()

module.exports = singleton