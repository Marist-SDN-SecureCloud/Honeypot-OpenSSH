# OpenSSH Honeypot
# Author:  Daniel Nicolas Gisolfi

USER=dgisolfi
IMAGE=ssh_honeypot
CONTAINER=ssh_honeypot

MAKE:
	@make clean
	@make build
	@make run

intro:
	@echo "OpenSSH Honeypot v2.0\n"

clean:
	-docker kill $(CONTAINER)
	-docker rm $(CONTAINER)
	-docker rmi $(IMAGE)

build: intro
	@docker build -t $(IMAGE) .

# Run the honeypot and TCP server
run: build
	@docker run -it --rm --name $(CONTAINER) -p22:22 -p2222:2222 $(IMAGE)

# Push Docker image to Docker Hub
publish: build
	@docker tag $(IMAGE) $(USER)/$(IMAGE):11.38
	@docker push $(USER)/$(IMAGE)

.PHONY: intro clean build run