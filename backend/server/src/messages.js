/**
 * Copyright 2020 Anicet Nougaret & contributors
 * See LICENCE.txt
 */

module.exports = {
    YOUR_ID: (id, name) => ({message:"Your id", id: id, name: name}),
    JOINED_ROOM: (roomId, usersND) => ({message:"Joined room", roomId:roomId, usersND:usersND}),
    FAILED_TO_JOIN_ROOM: (reason) => ({message: "Failed to join room", reason: reason}),
    USER_JOINED: (roomId, userND) => ({message:"User joined", roomId:roomId, userND:userND}),
    USER_LEFT: (roomId, userId) => ({message:"User left", roomId:roomId, userId:userId}),
    UPDATE_HOST: (roomId, userId) => ({message:"Update host", roomId:roomId, userId:userId}),
    ROOM_DELETED: (roomId) => ({message:"Game deleted", roomId:roomId}),
    GAME_STARTED: (roomId) => ({message:"Game started", roomId:roomId})
}