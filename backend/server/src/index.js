/**
 * Copyright 2020 Anicet Nougaret & contributors
 * See LICENCE.txt
 */

// Importing .env file
require('dotenv').config()

// External libraries
const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const port = process.env.PORT;
const server = http.createServer(express);
const wss = new WebSocket.Server({ server });

// Internal libraries
const RoomsManager = require('./RoomsManager')
const UsersManager = require('./UsersManager')

// Handling a connection
wss.on('connection', ws => {
    // Creating a user instance for this connection
    ws.id = getUniqueID();
    let user = UsersManager.createUser(ws.id, ws, "User#" + ws.id.substring(0, 3))

    console.log(`user ${ws.id} connected`)

    // Handling this connected user's messages
    ws.on('message', message => {
        let data = JSON.parse(message)
        console.log("Receiving from "+user.id+"|"+user.name+": "+message)

        UsersManager.handleMessage(data, user)
        RoomsManager.handleMessage(data, user)
    })

    // When it disconnects
    ws.on('close', (code, reason) => {
        UsersManager.removeUser(ws.id)

        reason = (reason != "" ? 'reason: '+reason : 'unknown reason')
        console.log(`user ${ws.id} disconnected for ${reason} with code: ${code}`)
    })
})

// Starting the server, uncomment 0.0... to host publicly for
// the entire world to see. (Assuming port is openned on your
// machine's firewall, and on your router's firewall)
server.listen(port, /*'0.0.0.0',*/ function() {
    console.log(`Server is listening on ${port}!`)
})

function getUniqueID () {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
    }
    return s4() + s4() + '-' + s4()
}