version ?= $(shell git describe --always)

image=odahub/dispatcher:$(version)
image_latest=odahub/dispatcher:latest

run: build
	docker run \
		-it \
		-u $(shell id -u) \
		-v /tmp/dev/log:/var/log/containers \
		-v /tmp/dev/workdir:/data/dispatcher_scratch \
		-v $(PWD)/conf:/dispatcher/conf \
		--rm \
		-p 8010:8000 \
		--name dev-oda-dispatcher \
		$(image) 

build:
	bash make.sh 
	git submodule update --init
	docker build  -t $(image)  \
		.


push: build
	docker tag $(image) $(image_latest)
	docker push $(image_latest)
	docker push $(image)


submodule-diff:
	(for k in $(shell git submodule | awk '{print $$2}'); do (cd $$k; pwd; git diff); done)
