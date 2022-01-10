FROM python:3.8
FROM integralsw/osa-python:11.1-11-g024d72b4-20200722-185528-refcat-43.0-heasoft-6.28-python-3.8.5


SHELL [ "bash", "-c" ]

#RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

ADD requirements.txt /requirements.txt


RUN source /init.sh && \
    python -c 'import xspec; print(xspec)'

RUN source /init.sh && \
    pip install pip --upgrade && \
    pip install -r /requirements.txt


ADD cdci_osa_plugin /cdci_osa_plugin
RUN source /init.sh && \
    pip install /cdci_osa_plugin

ADD dispatcher-plugin-integral-all-sky /dispatcher-plugin-integral-all-sky
RUN source /init.sh && \
    pip install -r /dispatcher-plugin-integral-all-sky/requirements.txt && \
    pip install /dispatcher-plugin-integral-all-sky

ADD oda_api /oda_api
RUN source /init.sh && \
    pip install -r /oda_api/requirements.txt && \
    pip install /oda_api

ADD ddaclient /ddaclient
RUN source /init.sh && \
    pip install /ddaclient

ADD dispatcher-plugin-antares /dispatcher-plugin-antares
RUN source /init.sh && \
    pip install -r /dispatcher-plugin-antares/requirements.txt && \
    pip install /dispatcher-plugin-antares

ADD dispatcher-plugin-polar /dispatcher-plugin-polar
RUN source /init.sh && \
    pip install -r /dispatcher-plugin-polar/requirements.txt && \
    pip install /dispatcher-plugin-polar

ADD dispatcher-plugin-gw /dispatcher-plugin-gw
RUN source /init.sh && \
    pip install /dispatcher-plugin-gw
    #(cd /dispatcher-plugin-gw; poetry install)
    #missing some section? poetry#3084?

ADD dispatcher-plugin-legacysurvey /dispatcher-plugin-legacysurvey
RUN source /init.sh && \
    pip install /dispatcher-plugin-legacysurvey
    #(cd /dispatcher-plugin-gw; poetry install)
    #missing some section? poetry#3084?

ADD cdci_data_analysis /cdci_data_analysis
RUN source /init.sh && \
    pip install -r /cdci_data_analysis/requirements.txt && \
    pip install /cdci_data_analysis

ADD static-js9 /static-js9 
ENV DISPATCHER_JS9_STATIC_DIR /static-js9

# why is it needed? why is it in a wrong place?
ADD dispatcher-plugin-gw/dispatcher_plugin_gw/config_dir/data_server_conf.yml /dispatcher/conf/conf.d/gw_data_server_conf.yml

# these will be mounted at runtime
ENV DISPATCHER_CONFIG_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml 
ENV CDCI_OSA_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml
ENV CDCI_POLAR_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/polar_data_server_conf.yml
ENV CDCI_ANTARES_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/antares_data_server_conf.yml

WORKDIR /data/dispatcher_scratch

RUN cd /data; \
    curl https://www.isdc.unige.ch/~savchenk/dispatcher-plugin-integral-data-dummy_prods-default.tgz | tar xvf - --strip-components 1

ADD entrypoint.sh /dispatcher/entrypoint.sh
ENTRYPOINT bash /dispatcher/entrypoint.sh
