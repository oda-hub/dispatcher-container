export PYTHONUNBUFFERED=0

#source /heasoft_init.sh

ls -tlroa /var/log/containers/

python /cdci_data_analysis/bin/run_osa_cdci_server.py -conf_file /dispatcher/conf/conf_env.yml -use_gunicorn 2>&1 | tee -a /var/log/containers/${CONTAINER_NAME}
