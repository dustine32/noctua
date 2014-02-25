####
#### Example of running locally:
####  M3LOC=http://localhost:6800 make start-app
####

## Variable to pass the location of the MMM server to the deploying
## app.
M3LOC ?= http://localhost:6800

## Variable to pass the location of the (optional) messaging server to
## the deploying app.
MSGLOC ?= http://localhost:3400

## Variable to pass the desired port to use to the messaging server at
## startup.
MSGPORT ?= 3400

## Testing.
TESTS = \
 $(wildcard js/*.js.tests)
TEST_JS = rhino
TEST_JS_FLAGS = -modules static/bbop.js -opt -1

###
### Building.
###

.PHONY: assemble-app
assemble-app:
	cp ../bbop-js/staging/bbop.js static/

###
### Tests.
###

.PHONY: test $(TESTS)
test: assemble-app $(TESTS)
$(TESTS):
	echo "trying: $@"
	$(TEST_JS) $(TEST_JS_FLAGS) -f $(@D)/$(@F)

###
### Commands/environment for application server.
###

##
.PHONY: start-app-dev
start-app-dev: assemble-app
	M3LOC=$(M3LOC) MSGLOC=$(MSGLOC) node server.js

## Start without copying bbop-js over.
.PHONY: start-app
start-app:
	M3LOC=$(M3LOC) MSGLOC=$(MSGLOC) node server.js

###
### Commands/environment for messaging server.
###

.PHONY: start-messenger-dev
start-messenger-dev: assemble-app
	MSGPORT=$(MSGPORT) node messenger.js

.PHONY: start-messenger
start-messenger:
	MSGPORT=$(MSGPORT) node messenger.js
