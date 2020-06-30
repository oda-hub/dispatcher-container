version ?= $(shell git describe --always)

image_tag=odahub/dispatcher:$(version)

run: build
	docker run $(image_tag) 

build:
	docker build  -t $(image_tag)  \
		.

push: build
	docker push $(image_tag)
