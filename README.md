# Build the FabScanPi Frontend

First install nodejs for your operating system.

http://nodejs.org/download/

Afterwards install grunt.

npm install -g grunt-cli

Then go to frontend directory and type : npm install
( all needed packages for build will be installed)
grunt build

After a successful build, the current version is located in the folder target/build/main
The files in this folder can be copied to the /usr/local/fabscanpi-server/www folder of
the FabScanPi server application.

If you are not developing on a pi, you can run grunt default, which starts a node server
on port 8001. By pointing your browser to http://localhost:8001 you can access the FabScanPI
GUI on your local machine. The backend server parts are connected through websockets.

