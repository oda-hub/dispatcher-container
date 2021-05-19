export PYTHONUNBUFFERED=TRUE

export XDG_CACHE_HOME=/tmp/xdg_cache_home
mkdir -pv $XDG_CACHE_HOME/astropy

ls -tlroa /var/log/containers/

# it might be better not to change directory
WORK_DIR=$PWD/$(date +%Y-%m-%d-%H-%M-%S)-$$

( 
    mkdir -pv $WORKDIR
    cd $WORKDIR

    python /cdci_data_analysis/bin/run_osa_cdci_server.py \
        -conf_file /dispatcher/conf/conf_env.yml \
        -debug \
        -use_gunicorn 2>&1 | tee -a /var/log/containers/${CONTAINER_NAME} -
)
