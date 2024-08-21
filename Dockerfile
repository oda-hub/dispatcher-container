FROM python:3.12
FROM integralsw/osa-python:11.1-11-g024d72b4-20200722-185528-refcat-43.0-heasoft-6.28-python-3.8.5


SHELL [ "bash", "-c" ]

#RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -


ADD static-js9 /static-js9 
ENV DISPATCHER_JS9_STATIC_DIR /static-js9

RUN source /init.sh && \
    python -c 'import xspec; print(xspec)'

# why is it needed? why is it in a wrong place?
ADD dispatcher-plugin-gw/dispatcher_plugin_gw/config_dir/data_server_conf.yml /dispatcher/conf/conf.d/gw_data_server_conf.yml
ADD dispatcher-plugin-legacysurvey/dispatcher_plugin_legacysurvey/config_dir/data_server_conf.yml /dispatcher/conf/conf.d/legacysurvey_data_server_conf.yml

# these will be mounted at runtime
ENV DISPATCHER_CONFIG_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml 
ENV CDCI_OSA_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml
ENV CDCI_POLAR_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/polar_data_server_conf.yml
ENV CDCI_ANTARES_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/antares_data_server_conf.yml
ENV CDCI_NB2W_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/nb_data_server_conf.yml


ADD requirements.txt /requirements.txt
ADD cdci_data_analysis /cdci_data_analysis
ADD oda_api /oda_api
ADD cdci_osa_plugin /cdci_osa_plugin
ADD dispatcher-plugin-integral-all-sky /dispatcher-plugin-integral-all-sky
ADD dispatcher-plugin-antares /dispatcher-plugin-antares
ADD ddaclient /ddaclient
ADD dispatcher-plugin-polar /dispatcher-plugin-polar
ADD dispatcher-plugin-gw /dispatcher-plugin-gw
ADD dispatcher-plugin-legacysurvey /dispatcher-plugin-legacysurvey
ADD dispatcher-plugin-nb2workflow /dispatcher-plugin-nb2workflow


RUN source /init.sh && \
    pip install pip --upgrade && \
    pip install -r /requirements.txt \
                /cdci_osa_plugin \
                /dispatcher-plugin-integral-all-sky \
                /oda_api \
                /ddaclient \
                /dispatcher-plugin-antares \
                /dispatcher-plugin-polar \
                /dispatcher-plugin-gw \
                /dispatcher-plugin-legacysurvey \
                /dispatcher-plugin-nb2workflow \
                /cdci_data_analysis

RUN source /init.sh && \
    python -c 'from gwpy.timeseries.timeseries import TimeSeries'

WORKDIR /data/dispatcher_scratch

RUN cd /data; \
    curl https://www.isdc.unige.ch/~savchenk/dispatcher-plugin-integral-data-dummy_prods-default.tgz | tar xzvf - --strip-components 1

ADD entrypoint.sh /dispatcher/entrypoint.sh
ENTRYPOINT bash /dispatcher/entrypoint.sh
