# IMPORTANT

G2O Server requires **data.xml** file, without it, it won't work properly!
You need to generate this file by yourself, in order to do that:

1. Run the default G2O Server
2. Join the server
3. Open up ingame debug console (tilde key)
4. Type: `generate data`
5. Copy the generated **data.xml** from `YOUR_GAME_PATH/Multiplayer/data.xml` to `SERVER_ROOT/data.xml`
6. Uncomment loading of **data.xml** file in **config.xml**

#### This file needs to be regenerated when you introduce new changes to:
- your game scripts (**gothic.dat**)
- your model scripts (.mds, e.g: **Humans.mds**)





# TODO:
* setup a unified way of transporting data between CEF <-> client <-> server
** json format probably works best (since we also will need it for redis)
*** need helpers to process on json strings (set, get, remove value from json string)
** add packet api to send json data with context freely


* cleanup directory structure. root -> server or client, instead of having directories like gamemode etc.
