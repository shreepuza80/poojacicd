SHELL=bash

my_repo_name=nja-pokemon-gha-demo

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

default: help

pokemon-down:  ## Shut down the pokemon app with docker compose
	export MY_REPO_NAME=$(my_repo_name)
	# remove the old containers, if any
	docker-compose down

pokemon-up: pokemon-down  ## Run just the pokemon app with docker compose
	export MY_REPO_NAME=$(my_repo_name)
	# build and run the containers
	docker-compose up --build -d pokemon-app
	#wait for app
	./pokemon-app/wait-for-app.sh localhost 3001
	# exercise the api
	curl -X GET localhost:3001

pokemon-test:  ## Run local unit tests
	@{ \
		pushd pokemon-app ;\
		npm install  ;\
		npm test ;\
		popd ;\
	}
