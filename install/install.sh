#!/bin/bash

set -e
set -u
set -o pipefail

usage() {
	echo "install.sh [-t type][-g groupname][-b backend][-f frontend][-e external]"
	echo " "
	echo "where:"
	echo "type      is the installation types"
	echo "          example: backend, frontend, server"
	echo "          if empty using 'backend'                "
	echo "groupname is the ansible group_vars name to be used"
	echo "          example: production, staging, test, ...  "
	echo "          if empty using 'production'                "
	echo "backend  is the FQDN of the back-end JupyterHub server"
	echo "          example: be.internal.example.org  "
	echo "          if empty using the local name for the back-end                "
	echo "frontend  is the FQDN of the front-end API/DB server"
	echo "          example: fe.example.org  "
	echo "          if empty using the external name for the back-end                "
	echo "external  is the external FQDN of the back-end JupyterHub server, reachable from the Internet"
	echo "          example: jphub.example.org  "
	echo "          if empty using the internal name of the back-end                "
	exit -1
}

while getopts ":v:g:" option; do
    case "${option}" in
        v)
            t=${OPTARG}
            ((t ==  "backend" || t == "frontend")) || usage
            ;;
        f)
            f=${OPTARG}
            ;;
        e)
            e=${OPTARG}
            ;;
        b)
            b=${OPTARG}
            ;;
        g)
            g=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
#if [ -z "${v}" ] || [ -z "${g}" ]; then
    #usage
#fi
if [ ! -z "${t}" ]; then
	WODTYPE="${e}"
else
	WODTYPE="backend"
fi
if [ ! -z "${b}" ]; then
	WODBEFQDN="${b}"
else
	WODBEFQDN=`hostname -f`
fi
if [ ! -z "${e}" ]; then
	WODBEEXTFQDN="${e}"
else
	WODBEEXTFQDN=$WODBEFQDN
fi
if [ ! -z "${f}" ]; then
	WODFEFQDN="${f}"
else
	WODFEFQDN=$WODBEFQDN
fi
if [ ! -z "${g}" ]; then
	WODGROUP="${g}"
else
	WODGROUP="production"
fi
export WODGROUP WODFEFQDN WODBEFQDN WODBEEXTFQDN WODTYPE
export WODBEIP=`host $WODBEFQDN | cut -d' ' -f4`
export WODDISTRIB=`grep -E '^ID=' /etc/os-release | cut -d= -f2 | sed 's/"//g'`-`grep -E '^VERSION_ID=' /etc/os-release | cut -d= -f2 | sed 's/"//g'`

echo "Installing a Workshop on Demand $WODTYPE environment"
echo "Using frontend $WODFEFQDN"
if [ $WODTYPE = "backend" ]; then
	echo "Using groupname $WODGROUP"
	echo "Using backend $WODBEFQDN ($WODBEIP)"
	echo "Using external backend $WODBEEXTFQDN"
fi

# redirect stdout/stderr to a file
mkdir -p $HOME/.jupyter
exec &> >(tee $HOME/.jupyter/install.log)

# Get path of execution
EXEPATH=`dirname "$0"`
EXEPATH=`( cd "$EXEPATH" && pwd )`

# Call the distribution specific install script
echo "Installing $WODDISTRIB specificities for $WODTYPE"
$EXEPATH/install-$WODTYPE-$WODDISTRIB.sh

# Call the common install script to finish install
echo "Installing common remaining stuff"
$EXEPATH/install-$WODTYPE-common.sh