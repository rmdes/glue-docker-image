APP_NAME := glue30

docker-build: ./Dockerfile
	docker build -t $(APP_NAME) .
