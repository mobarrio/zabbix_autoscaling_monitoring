#!/bin/bash 

#########################################################################
export zabbixServer='192.168.1.1'
export zabbixApiUrl="http://$zabbixServer/zabbix/api_jsonrpc.php"

export zabbixUsername='Admin'
export zabbixPassword='zabbix'

header='Content-Type:application/json'

# Comandos
export CURL=/usr/bin/curl
export JQ=/usr/bin/jq
export ZBX_TOKEN=""
#########################################################################


# get Token
zbx_gettoken() {
   ZBX_TOKEN=$(${CURL} -s -X POST -H "${header}" -d '{"jsonrpc": "2.0", "method":"user.login", "params":{"user":"'${zabbixUsername}'", "password":"'${zabbixPassword}'"},"auth": null,"id":0}' ${zabbixApiUrl} | ${JQ} -r ".result")
   echo $ZBX_TOKEN
}

# get HostID
zbx_getHostID() {
   if [ $# = 0 ]; then
        echo "ERROR: Parametro incorrecto. Se espera el HostID"
        exit 1
   fi
   ZBX_HOSTNAME="${1}"
   ZBX_HOSTID=$(${CURL} -s -X POST -H "${header}" -d '{"jsonrpc": "2.0", "method": "host.get", "params": { "filter": { "host": [ "'${ZBX_HOSTNAME}'" ] } }, "auth": "'${ZBX_TOKEN}'", "id": 1 }' $zabbixApiUrl | ${JQ} -r ".result[].hostid")
   echo $ZBX_HOSTID
}

# disableHostByName
zbx_disableHostByName() {
   if [ $# = 0 ]; then
        echo "ERROR: Parametro incorrecto. Se espera el Hostname"
        exit 1
   fi
   ZBX_HOSTNAME="${1}"
   ZBX_HOSTID=$(zbx_getHostID $ZBX_HOSTNAME)
   zbx_disableHostByID $ZBX_HOSTID
}

# enableHostByName
zbx_enableHostByName() {
   if [ $# = 0 ]; then
        echo "ERROR: Parametro incorrecto. Se espera el Hostname"
        exit 1
   fi
   ZBX_HOSTNAME="${1}"
   ZBX_HOSTID=$(zbx_getHostID $ZBX_HOSTNAME)
   zbx_enableHostByID $ZBX_HOSTID
}

# disableHostByID
zbx_disableHostByID() {
   if [ $# = 0 ]; then
        echo "ERROR: Parametro incorrecto. Se espera el HostID"
        exit 1
   fi
   ZBX_HOSTID="${1}"
   $CURL -s -X POST -H "${header}" -d '{"jsonrpc": "2.0", "method":"host.update", "params": {"hostid": "'${ZBX_HOSTID}'", "status": 1 }, "auth": "'${ZBX_TOKEN}'", "id": 1 }' ${zabbixApiUrl} 2>&1 >/dev/null
}

# enableHostByID
zbx_enableHostByID() {
   if [ $# = 0 ]; then
        echo "ERROR: Parametro incorrecto. Se espera el HostID"
        exit 1
   fi
   ZBX_HOSTID="${1}"
   $CURL -s -X POST -H "${header}" -d '{"jsonrpc": "2.0", "method":"host.update", "params": {"hostid": "'${ZBX_HOSTID}'", "status": 0 }, "auth": "'${ZBX_TOKEN}'", "id": 1 }' ${zabbixApiUrl} 2>&1 >/dev/null
}


# deleteHostByID
zbx_deleteHostByID() {
   if [ $# = 0 ]; then
        echo "ERROR: Parametro incorrecto. Se espera el HostID"
        exit 1
   fi
   ZBX_HOSTID="${1}"
   $CURL -s -X POST -H "${header}" -d '{"jsonrpc": "2.0", "method":"host.delete", "params": ["'${ZBX_HOSTID}'"], "auth": "'${ZBX_TOKEN}'", "id": 1 }' ${zabbixApiUrl} 2>&1 >/dev/null
}

# deleteHostByName
zbx_deleteHostByName() {
   if [ $# = 0 ]; then
        echo "ERROR: Parametro incorrecto. Se espera el Hostname"
        exit 1
   fi
   ZBX_HOSTNAME="${1}"
   ZBX_HOSTID=$(zbx_getHostID $ZBX_HOSTNAME)
   zbx_deleteHostByID $ZBX_HOSTID
}

# zbx_usage
zbx_usage() {
   echo 
   echo "Usage:"
   echo "   zbxapi.sh [deleteByName|deleteByID|enableByName|disableByName|enableByID|disableByID] HOSTNAME"
   echo 
   echo " Ejemplo desactivar host por nombre"
   echo "   # zbxapi.sh disableByName server1"
   echo 
   exit 1
}

#---------------------------------------------
# main()

ZBX_TOKEN=$(zbx_gettoken)

if [ $# -lt 1 ]; then
   zbx_usage
   exit 1
fi

cmd="${1}"
shift
case "${cmd}" in
        "deleteByName" )
                zbx_deleteHostByName ${*}
                ;;
        "deleteByID" )
                zbx_deleteHostByID ${*}
                ;;
        "enableByName" )
                zbx_enableHostByName ${*}
                ;;
        "disableByName" )
                zbx_disableHostByName ${*}
                ;;
        "enableByID" )
                zbx_enableHostByID ${*}
                ;;
        "disableByID" )
                zbx_disableHostByID ${*}
                ;;
        * )
                zbx_usage
                ;;
esac

exit 0