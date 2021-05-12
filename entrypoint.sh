export PYTHONUNBUFFERED=TRUE

export XDG_CACHE_HOME=/tmp/xdg_cache_home
mkdir -pv $XDG_CACHE_HOME/astropy

ls -tlroa /var/log/containers/

if true; then
    export DISPATCHER_CONFIG_FILE=/dispatcher/conf/conf_env.yml
    gunicorn --workers 1 cdci_data_analysis.flask_app.app:app -b 0.0.0.0:8000 --log-level DEBUG --timeout 600
else
    python /cdci_data_analysis/bin/run_osa_cdci_server.py \
        -conf_file /dispatcher/conf/conf_env.yml \
        -debug \
        -use_gunicorn 2>&1 | tee -a /var/log/containers/${CONTAINER_NAME} -
fi
