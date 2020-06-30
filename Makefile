version ?= $(shell git describe --always)

image=odahub/dispatcher:$(version)

run: build
	docker run \
		-u $(shell id -u) \
		-v /tmp/dev/log:/var/log/containers \
		$(image) 

build:
	docker build  -t $(image)  \
		.

push: build
	docker push $(image)
