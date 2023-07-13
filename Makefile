version ?= $(shell git describe --always)
version_sortable ?= $(shell git log -1 --format="%at" | xargs -I{} date -d @{} +%y%m%d-%H%M%S)

image=odahub/dispatcher:$(version)
image_sortable=odahub/dispatcher:$(version_sortable)
image_latest=odahub/dispatcher:latest

run: build
	docker run \
		-it \
		-u $(shell id -u) \
		-v /tmp/dev/log:/var/log/containers \
		-v /tmp/dev/workdir:/data/dispatcher_scratch \
		-v $(PWD)/conf:/dispatcher/conf \
		-e DISPATCHER_CONFIG_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml \
		-e DISPATCHER_GUNICORN=yes \
		--rm \
		-p 8010:8000 \
		--name dev-oda-dispatcher \
		$(image) 

prepare-js9:
	bash make.sh $@

update:
	bash make.sh 
	git submodule update --init

build: static-js9
	DOCKER_BUILDKIT=1 docker build  -t $(image) .


static-js9:
	bash make.sh prepare-js9


push: build
	docker tag $(image) $(image_latest)
	docker tag $(image) $(image_sortable)
	docker push $(image_latest)
	docker push $(image_sortable)
	docker push $(image)


submodule-diff:
	(for k in $(shell git submodule | awk '{print $$2}'); do (cd $$k; pwd; git diff); done)

flower:
	docker run -it --entrypoint celery $(image) -A cdci_data_analysis.flask_app.tasks.celery flower -l info --port=5555
