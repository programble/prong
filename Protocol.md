# Prong Multiplayer Protocol Specification (of sorts)

## Handshake Process

Client:

    CONNECT protocol_version name
    n n Z*

### On matching `protocol_version`

Server:

    CONNECTION_ACCEPTED protocol_version
    n n

The client should then be put in the "waiting" state.

### On wrong `protocol_version`

Server:

    CONNECT_REJECTED protocol_version
    n n

The server should send nothing else to the client afterwards.

## Waiting State

The waiting state is the initial state of all clients. In this state, clients
are waiting for an opponent to start a game with.
