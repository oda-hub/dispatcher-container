FROM python:3.8
#FROM integralsw/osa-python:11.1-11-g024d72b4-20200722-185528-refcat-43.0-heasoft-6.28-python-3.8.5

#RUN echo 'source /init.sh' >> ~/.bashrc

#SHELL [ "bash", "-c" ]

#RUN export && \
#    which fstatistic && \
#    cat /init.sh

RUN pip install pip --upgrade

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ADD cdci_data_analysis /cdci_data_analysis

ADD cdci_osa_plugin /cdci_osa_plugin
RUN pip install /cdci_osa_plugin

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

ADD dispatcher-plugin-polar /dispatcher-plugin-polar
RUN pip install -r /dispatcher-plugin-polar/requirements.txt && \
    pip install /dispatcher-plugin-polar

RUN pip install -r /cdci_data_analysis/requirements.txt && \
    pip install /cdci_data_analysis

ADD static-js9 /static-js9 
ENV DISPATCHER_JS9_STATIC_DIR /static-js9

# these will be mounted at runtime
ENV DISPATCHER_CONFIG_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml 
ENV CDCI_OSA_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml
ENV CDCI_POLAR_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/polar_data_server_conf.yml
ENV CDCI_MAGIC_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/magic_data_server_conf.yml
ENV CDCI_ANTARES_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/antares_data_server_conf.yml

WORKDIR /data/dispatcher_scratch

RUN cd /data; \
    curl https://www.isdc.unige.ch/~savchenk/dispatcher-plugin-integral-data-dummy_prods-default.tgz | tar xvf - --strip-components 1

ADD entrypoint.sh /dispatcher/entrypoint.sh
ENTRYPOINT bash /dispatcher/entrypoint.sh
