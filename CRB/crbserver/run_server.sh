#STOP
./_rel/crbserver_release/bin/crbserver_release stop
sleep 1
#STATUS
./_rel/crbserver_release/bin/crbserver_release status
sleep 1
#RUN
./_rel/crbserver_release/bin/crbserver_release start
sleep 1 
#STATUS
./_rel/crbserver_release/bin/crbserver_release status                         
