hud for dev_flushed (add)
============

what it does
------------

- simple hud script that sends the message `FLUSHED:<ownerKey>` on channel `999` when touched.
- designed to work with the `sl_anima.lsl` flusher script (which listens on channel 999).

installation
------------

1. create a small prim to act as your hud (or reuse an existing hud prim).
2. open the prim's contents and add `hud_flusher.lsl` (copy the script file into the prim).
3. save/compile the script in the prim.
4. attach the prim to a HUD attachment point (e.g., `HUD Center`).

usage
-----

- touch the hud prim to send the activation message. the prim will announce back to you what it sent.
- the dev_flushed (add) object must be in the same region (region-wide message) or otherwise able to receive messages on channel 999.

notes
-----

- `sl_anima.lsl` supports a few activation patterns. the hud uses the simplest: `FLUSHED:<ownerKey>` which triggers the effect on the flusher if the payload equals the flusher's owner.
- if you want the HUD to target a specific dev_flushed (add) object, we can extend the hud to listen for `I_AM_FLUSHER:` announcements and send `FLUSHED:<ownerKey>:<flusherID>` instead.
