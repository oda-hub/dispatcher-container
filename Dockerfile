FROM python:3.7

RUN pip install pip --upgrade

ADD ./dispatcher/ddosaclient /dispatcher/ddosaclient
RUN cd /dispatcher/ddosaclient && \
    conda install --yes --file requirements.txt  && \
    python setup.py install

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt


ENV CDCI_OSA_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/osa_data_server_conf.yml
ENV CDCI_POLAR_PLUGIN_CONF_FILE=/dispatcher/conf/conf.d/polar_data_server_conf.yml


ARG uid
RUN useradd integral -u $uid
USER integral

WORKDIR /data/dispatcher_scratch

ADD entrypoint.sh /dispatcher/entrypoint.sh
ENTRYPOINT bash /dispatcher/entrypoint.sh
