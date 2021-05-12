FROM python:3.8

RUN pip install pip --upgrade

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ADD cdci_data_analysis /cdci_data_analysis

ADD cdci_osa_plugin /cdci_osa_plugin
RUN pip install -r /cdci_osa_plugin/requirements.txt && \
    pip install /cdci_osa_plugin

ADD dispatcher-plugin-integral-all-sky /dispatcher-plugin-integral-all-sky
RUN pip install -r /dispatcher-plugin-integral-all-sky/requirements.txt && \
    pip install /dispatcher-plugin-integral-all-sky

ADD oda_api /oda_api
RUN pip install -r /oda_api/requirements.txt && \
    pip install /oda_api

ADD cdci_magic_plugin /cdci_magic_plugin
RUN pip install -r /cdci_magic_plugin/requirements.txt && \
    pip install /cdci_magic_plugin

ADD ddaclient /ddaclient
RUN pip install /ddaclient

ADD magic-backend /magic-backend
RUN pip install -r /magic-backend/requirements.txt && \
    pip install /magic-backend

ADD dispatcher-plugin-antares /dispatcher-plugin-antares
RUN pip install -r /dispatcher-plugin-antares/requirements.txt && \
    pip install /dispatcher-plugin-antares

RUN pip install -r /cdci_data_analysis/requirements.txt && \
    pip install /cdci_data_analysis

# these will be mounted at runtime
ENV DISPATCHER_CONFIG_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml 
ENV CDCI_OSA_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml
ENV CDCI_POLAR_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/polar_data_server_conf.yml
ENV CDCI_MAGIC_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/magic_data_server_conf.yml

WORKDIR /data/dispatcher_scratch

ADD entrypoint.sh /dispatcher/entrypoint.sh
ENTRYPOINT bash /dispatcher/entrypoint.sh
