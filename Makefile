dev:
	docker-compose -f docker-compose.yml up -d --build 

# Debug
interactive:
	docker-compose -f docker-compose.yml up --build

# Stop all Containers
stop:
	docker-compose -f docker-compose.yml stop

###########
# HELPERS #
###########

# Create SSL Keypair for Development
ssh-keygen:
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout resources/certs/changeme.key -out resources/certs/changeme.crt

# Install PHP Dependencies via Composer
composer-install:
	docker run --rm --name compose-maintainence --interactive \
    --volume $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/src:/app \
    --user $(id -u):$(id -g) \
    composer install --ignore-platform-reqs

# Install Dev PHP Dependencies via Composer
composer-install-dev:
	docker run --rm --name compose-maintainence-dev --interactive \
    -v $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/src:/app \
    --user $(id -u):$(id -g) \
    composer install --ignore-platform-reqs --dev

# Update Dev PHP Dependencies via Composer
composer-update:
	docker run --rm --name compose-maintainence-update --interactive \
    --volume $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/src:/app \
    --user $(id -u):$(id -g) \
    composer update --ignore-platform-reqs

# Update Dev PHP Dependencies via Composer - usage make composer-add-dep module=module/namehere
composer-add-dep:
	docker run --rm --name compose-maintainence-update --interactive \
    --volume $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/src:/app \
    --user $(id -u):$(id -g) \
    composer require $(module) --ignore-platform-reqs

# Install JS Dependencies via NPM
npm-install:
	docker run --rm --name js-maintainence --interactive \
	-v $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/src:/usr/src/app \
	-w /usr/src/app \
	node:8 /bin/bash -ci "npm install && node_modules/.bin/gulp --production"

# Install Dev JS Dependencies via NPM
npm-install-dev:
	docker run --rm --name js-maintainence-dev --interactive \
	-v $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/src:/usr/src/app \
	-w /usr/src/app \
	node:8 /bin/bash -ci "npm install && node_modules/.bin/gulp"

# Gulp Runner
gulp:
	docker run --rm --name js-maintainence-dev --interactive \
	-v $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/src:/usr/src/app \
	-w /usr/src/app \
	node:8 /bin/bash -ci "node_modules/.bin/gulp"

# Wait for containers to initialize
wait:
	sleep 30

.ONESHELL: