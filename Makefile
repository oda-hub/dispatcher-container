version ?= $(shell git describe --always)

image=odahub/dispatcher:$(version)

run: build
	docker run \
		-it \
		-u $(shell id -u) \
		-v /tmp/dev/log:/var/log/containers \
		-v /tmp/dev/workdir:/data/dispatcher_scratch \
		-v $(PWD)/conf:/dispatcher/conf \
		--rm \
		-p 8000:8000 \
		--name dev-oda-dispatcher \
		$(image) 

build:
	bash make.sh 
	git submodule update --init
	docker build  -t $(image)  \
		.


push: build
	docker push $(image)
