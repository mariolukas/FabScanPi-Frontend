[![Python Support](https://img.shields.io/badge/License-AGPL v3-blue.svg)](http://www.gnu.org/licenses/agpl-3.0.de.html)
[![Build Status](https://travis-ci.org/mariolukas/FabScanPi-Frontend.svg?branch=master)](https://travis-ci.org/mariolukas/FabScanPi-Frontend)

# FabScanPi Frontend

## About
This is the FabScanPi Frontend. If you want only to use the FabScanPi, visit the [FabScanPi
server repository](https://github.com/mariolukas/FabScanPi-Frontend). The Frontend repository is
more related to developers.

## Build the FabScanPi Frontend

First install nodejs for your operating system.

http://nodejs.org/download/

Afterwards install grunt.

``npm install -g grunt-cli```

Then go to frontend directory and install all needed packages
```npm install -g``

You can build the Frontend with:

```grunt build```

Afterwards all built files can be found in the ```target/build/main```
The files in this folder can be copied to the ```/usr/local/fabscanpi-server/www``` folder of
the FabScanPi server application.

If you are not developing on a pi, you can run ```grunt default```, which starts a node server
on port 8001. By pointing your browser to ```http://localhost:8001``` you can access the FabScanPI
GUI on your local machine. The backend server parts are connected through websockets.





