DOCKER_COMPOSE_FILE = workspace/docker-compose.yaml
DOCKER_COMPOSE_SERVICE= workspace
YQ := $(shell command -v yq 2> /dev/null)

INST ?= ./install-local.sh

ws-build: ws-down
	@docker-compose -f $(DOCKER_COMPOSE_FILE) build

ws-rebuild: ws-clean ws-build

ws-up: 
	@docker-compose -f $(DOCKER_COMPOSE_FILE) ps -q | grep -q . && \
	echo "$@: containers are already running" ||  \
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

ws-down:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) ps -q | grep . && \
	docker-compose -f $(DOCKER_COMPOSE_FILE) down || \
	echo "$@: no running containers to stop."

ws-shell: ws-up
	@docker-compose -f $(DOCKER_COMPOSE_FILE) ps -q | grep . && \
    docker-compose -f $(DOCKER_COMPOSE_FILE) exec ${DOCKER_COMPOSE_SERVICE} /bin/bash || \
    echo "$@: no unning containers to run shell in."

ws-run: ws-up
	@docker-compose -f $(DOCKER_COMPOSE_FILE) ps -q | grep . && \
    docker-compose -f $(DOCKER_COMPOSE_FILE) exec ${DOCKER_COMPOSE_SERVICE} /bin/bash -c "/bin/bash ${INST} && /bin/bash" || \
	echo "$@: no unning containers to run script in."

ws-clean: ws-down
ifndef YQ
	$(error "yq is not available")
endif
	@IMAGE_NAME=$$(yq .services.workspace.image ${DOCKER_COMPOSE_FILE}); \
	docker image inspect $${IMAGE_NAME} > /dev/null 2>&1 && \
	docker image rm -f $${IMAGE_NAME} || \
	echo "$@: image $${IMAGE_NAME} does not exist, skipping removal."

.PHONY: ws-build ws-rebuild ws-up ws-down ws-shell ws-run ws-clean
