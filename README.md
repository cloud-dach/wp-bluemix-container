# Docker WordPress for Bluemix
A Docker image for running WordPress on IBM Bluemix Containers modified Tutorial from Miguel Clement:
http://blog.ibmjstart.net/2015/05/22/wordpress-on-bluemix-containers/

// clone git repo and change into directory<br />
git clone https://github.com/cloud-dach/wp-bluemix-container.git

// provide ssh public key<br />
create own ssh key or use existing rsakey and copy id_rsa.pub to the cloned directory

// build the docker image and tag in local registry<br />
docker build -t [USERNAME/]wordpress .

// tag the wordpress image for pushing up to your bluemix registry<br />
docker tag [USERNAME/]wordpress registry.ng.bluemix.net/[YOURBLUEMIXREGISTRY]/wordpress

// push the image to Bluemix<br />
docker push registry.ng.bluemix.net/[YOURBLUEMIXREGISTRY]/wordpress

// create docker volume in Bluemix<br />
cf ic volume create [Volume Name]

// create a CF Application in Bluemix and bind the ClearDB MySQL Database to the app, the app will provide the linkage to the CF ENV for the docker container, the appname like CFAppName is used in the next step, restage!<br />

// create the docker container and bind it to the app and volume<br />
ice run --volume [Volume Name]:/var/www/html --publish 80 --publish 22  --bind CFAppName --name Containername registry.ng.bluemix.net/[YOURBLUEMIXREGISTRY]/wordpress:latest

//check container state with ice ps until running<br />
ice ps

// request ips and bind to container
ice ip request... ice ip list ... ice ip bind YOURIP YOURCONTAINERID
// access the port 80 on your public IP and you should see the wordpress config dialog










