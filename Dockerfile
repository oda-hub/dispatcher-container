FROM python:3.6

RUN pip install pip --upgrade

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ADD cdci_data_analysis /cdci_data_analysis

RUN pip install -r /cdci_data_analysis/requirements.txt && \
    pip install /cdci_data_analysis

ADD cdci_osa_plugin /cdci_osa_plugin
RUN pip install -r /cdci_osa_plugin/requirements.txt && \
    pip install  /cdci_osa_plugin

ADD cdci_api_plugin /cdci_api_plugin
RUN pip install -r /cdci_api_plugin/requirements.txt && \
    pip install  /cdci_api_plugin

RUN mkdir -pv /dispatcher/conf/conf.d/
ADD conf/conf.d/osa_data_server_conf.yml /dispatcher/conf/conf.d/osa_data_server_conf.yml

ENV CDCI_OSA_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml
ENV CDCI_POLAR_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/polar_data_server_conf.yml

WORKDIR /data/dispatcher_scratch

ADD entrypoint.sh /dispatcher/entrypoint.sh
ENTRYPOINT bash /dispatcher/entrypoint.sh

#3233ac3
#3233ac3
#3233ac3
#3233ac3
#3233ac3
#3233ac3
