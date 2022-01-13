APP_NAME := glue30

docker-build: build/Dockerfile
	docker build -t $(APP_NAME) build/
