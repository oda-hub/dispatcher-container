export PYTHONUNBUFFERED=TRUE

export XDG_CACHE_HOME=/tmp/xdg_cache_home
mkdir -pv $XDG_CACHE_HOME/astropy

ls -tlroa /var/log/containers/

python /cdci_data_analysis/bin/run_osa_cdci_server.py \
    -conf_file /dispatcher/conf/conf_env.yml \
    -debug \
    -use_gunicorn 2>&1 | tee -a /var/log/containers/${CONTAINER_NAME} -
