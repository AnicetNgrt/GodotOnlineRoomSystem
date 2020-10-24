# Websocket online room system boilerplate for Godot Engine

This is a template you can start any (casual) multiplayer project from.

It implements the very popular **game room** and **secret code connection system**. Which you
certainly have already experienced in games such as **Among Us** or **Agar.io**.

## The system

In this room system a client (or frontent) (the player's version of the software) connects via a 
networking protocol to a server (a private and confidential software, which is part of the backend).

The client declares itself with a name the player has chosen through the game's UI,
and the server then accepts the connection and assigns an ID to the client.

Then the player is prompted with two choices: create a game (or room) or join a game (or room).

When a player chooses to create a game, the room's code is given to it by the server. The player can 
then give it to the other players for them to join with.

When a player chooses to connect, it has to enter the room's code.

When someone joins or leaves a room, all the guests are notified.

When the room has no guests anymore, it is automatically deleted.

When all guests declare themselves as ready, the game starts.

Once a game is started, no one can join it anymore.

## Architechture and stack

