DOCKERFILE ?=Dockerfile
all:
	go get -d -v ./...
	go build
	docker build -f ../agent_docker/$(DOCKERFILE) -t aikaan/aind:latest ../agent_docker/.

clean:
	go clean
