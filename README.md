p2p terminal chat
=================

Minimalistic terminal chat client. Uses UDP holepunching to create a p2p connection.

As unencrypted UDP messages go, it is not secure by any means.

Example usage:
```
ruby chat.rb cloud.vgmoose.com 4653 my-chat-topic
```

There is a hosted `server.py` which will act as middleman for setting up the p2p connection at `cloud.vgmoose.com:4653`. If you want to host your own though, feel free.
