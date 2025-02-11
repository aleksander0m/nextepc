#!/bin/bash

version=0.9.0

display_help() {
    echo "dbconf.sh: Open5GS Database Configuration Tool ($version)"
    echo "COMMANDS:" >&2
    echo "   add {imsi key opc}: adds a user to the database with default values"
    echo "   remove {imsi}: removes a user from the database"
    echo "   reset: WIPES OUT the database and restores it to an empty default"
    echo "   static_ip {imsi ip4}: adds a static IP assignment to an already-existing user"
    echo "   static_ip6 {imsi ip6}: adds a static IPv6 assignment to an already-existing user"
    echo "   type {imsi type}: changes the PDN-Type of the first PDN: 0 = IPv4, 1 = IPv6, 2 = IPv4v6, 3 = v4 OR v6"
    echo "   help: displays this message and exits"
    echo "   default values are as follows: APN \"internet\", dl_bw/ul_bw 1 Gbps, PGW address is 127.0.0.3, IPv4 only"
}


if [ "$#" -lt 1 ]; then
	display_help
	exit 1
fi

if [ "$1" = "help" ]; then
	display_help
	exit 1
fi

if [ "$1" = "add" ]; then
	if [ "$#" -eq 4 ]; then
		IMSI=$2 
		KI=$3
		OPC=$4

		mongo --eval "db.subscribers.update({\"imsi\" : \"$IMSI\"}, { \$setOnInsert: { \"imsi\" : \"$IMSI\", \"pdn\" : [ { \"apn\" : \"internet\", \"_id\" : new ObjectId(), \"pcc_rule\" : [ ], \"pgw\" : { \"addr\" : \"127.0.0.3\" }, \"ambr\" : { \"downlink\" : NumberLong(1024000), \"uplink\" : NumberLong(1024000) }, \"qos\" : { \"qci\" : NumberInt(9), \"arp\" : { \"priority_level\" : NumberInt(8), \"pre_emption_vulnerability\" : NumberInt(1), \"pre_emption_capability\" : NumberInt(0) } }, \"type\" : NumberInt(0) } ], \"ambr\" : { \"downlink\" : NumberLong(1024000), \"uplink\" : NumberLong(1024000) }, \"subscribed_rau_tau_timer\" : NumberInt(12), \"network_access_mode\" : NumberInt(2), \"subscriber_status\" : NumberInt(0), \"access_restriction_data\" : NumberInt(32), \"security\" : { \"k\" : \"$KI\", \"amf\" : \"8000\", \"op\" : null, \"opc\" : \"$OPC\" }, \"__v\" : 0 } }, upsert=true);" open5gs
		exit 0
	fi

	if [ "$#" -eq 5 ]; then
		IMSI=$2 
		IP=$3
		KI=$4
		OPC=$5

		mongo --eval "db.subscribers.update({\"imsi\" : \"$IMSI\"}, { \$setOnInsert: { \"imsi\" : \"$IMSI\", \"pdn\" : [ { \"apn\" : \"internet\", \"_id\" : new ObjectId(), \"pcc_rule\" : [ ], \"pgw\" : { \"addr\" : \"127.0.0.3\" }, \"ambr\" : { \"downlink\" : NumberLong(1024000), \"uplink\" : NumberLong(1024000) }, \"qos\" : { \"qci\" : NumberInt(9), \"arp\" : { \"priority_level\" : NumberInt(8), \"pre_emption_vulnerability\" : NumberInt(1), \"pre_emption_capability\" : NumberInt(0) } }, \"type\" : NumberInt(0), \"addr\" : \"$IP\" } ], \"ambr\" : { \"downlink\" : NumberLong(1024000), \"uplink\" : NumberLong(1024000) }, \"subscribed_rau_tau_timer\" : NumberInt(12), \"network_access_mode\" : NumberInt(2), \"subscriber_status\" : NumberInt(0), \"access_restriction_data\" : NumberInt(32), \"security\" : { \"k\" : \"$KI\", \"amf\" : \"8000\", \"op\" : null, \"opc\" : \"$OPC\" }, \"__v\" : 0 } }, upsert=true);" open5gs
		exit 0
	fi

	echo "dbconf.sh: incorrect number of args, format is \"dbconf.sh add imsi key opc\""
	exit 1
fi

if [ "$1" = "remove" ]; then
	if [ "$#" -ne 2 ]; then
		echo "dbconf.sh: incorrect number of args, format is \"dbconf.sh remove imsi\""
		exit 1
	fi

	IMSI=$2 
	mongo --eval "db.subscribers.remove({\"imsi\": \"$IMSI\"});" open5gs
	exit 0
fi

if [ "$1" = "reset" ]; then
	if [ "$#" -ne 1 ]; then
		echo "dbconf.sh: incorrect number of args, format is \"dbconf.sh reset\""
		exit 1
	fi

	mongo --eval "db.subscribers.remove({});" open5gs
	exit 0
fi

if [ "$1" = "static_ip" ]; then
	if [ "$#" -ne 3 ]; then
		echo "dbconf.sh: incorrect number of args, format is \"dbconf.sh static_ip imsi ip\""
		exit 1
	fi
	IMSI=$2 
	IP=$3

	mongo --eval "db.subscribers.update({\"imsi\": \"$IMSI\"},{\$set: { \"pdn.0.addr\": \"$IP\" }});" open5gs
	exit 0
fi

if [ "$1" = "static_ip6" ]; then
	if [ "$#" -ne 3 ]; then
		echo "dbconf.sh: incorrect number of args, format is \"dbconf.sh static_ip6 imsi ip\""
		exit 1
	fi
	IMSI=$2 
	IP=$3

	mongo --eval "db.subscribers.update({\"imsi\": \"$IMSI\"},{\$set: { \"pdn.0.addr6\": \"$IP\" }});" open5gs
	exit 0
fi

if [ "$1" = "type" ]; then
	if [ "$#" -ne 3 ]; then
		echo "dbconf.sh: incorrect number of args, format is \"dbconf.sh type imsi type\""
		exit 1
	fi
	IMSI=$2 
	TYPE=$3

	mongo --eval "db.subscribers.update({\"imsi\": \"$IMSI\"},{\$set: { \"pdn.0.type\": NumberInt($TYPE) }});" open5gs
	exit 0
fi

display_help
