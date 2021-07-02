export PYTHONUNBUFFERED=TRUE

export XDG_CACHE_HOME=/tmp/xdg_cache_home
mkdir -pv $XDG_CACHE_HOME/astropy

ls -tlroa /var/log/containers/


( 
    export HOME_OVERRRIDE=$PWD/runtime-home
    mkdir -pv $HOME_OVERRRIDE

    source /init.sh
    
    python -c 'import xspec; print(xspec)'

   # it might be better not to change directory, if jobs need to be preserved between restarts
   # WORK_DIR=$PWD/$(date +%Y-%m-%d-%H-%M-%S)-$$
   # mkdir -pv $WORK_DIR
   # cd $WORK_DIR
    echo -e "\033[31mworking in $PWD\033[0m"

    if [ ${DISPATCHER_GUNICORN:-no} == "yes" ]; then
        gunicorn \
            'cdci_data_analysis.flask_app.app:load_cli_app("/dispatcher/conf/conf_env.yml")' \
            --bind 0.0.0.0:8000 \
            --workers 8 \
            --preload \
            --timeout 300 \
            --log-level debug
    else
        python /cdci_data_analysis/bin/run_osa_cdci_server.py \
            -conf_file /dispatcher/conf/conf_env.yml \
            -debug \
            -use_gunicorn 2>&1 | tee -a /var/log/containers/${CONTAINER_NAME} -
    fi
)
