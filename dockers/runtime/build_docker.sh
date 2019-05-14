#! /bin/bash


DOCKER_REG=192.168.199.13
DOCKER_USR=admin
DOCKER_PSW=password
DOCKER_PUSH=“false”


DOCKER_IMAGE_PORT="80"
DOCKER_IMAGE_NAME="aws"
DOCKER_IMAGE_VER="1.0"
DOCKER_IMAGE_CLEAN="false"
DOCKER_IMAGE_RUN="false"

ZIP_FILENAME="ROOT"
WAR_FILENAME="CompanyNews.war"

AUTO_MODE="false"
SYNC_IMG="false"
SCRIPT_NAME=$(basename $0)

errorExit () {
    echo -e "ERROR: $1"; echo
    exit 1
}


# Check the port will be export from container.
function port_check()
{
	CHECK_PORT=$1
	psname=`lsof -i:${CHECK_PORT}|awk '{print $1}'`
	psid=`lsof -i:$CHECK_PORT|awk '{print $2}'`
	if [ -n "$psname" ]; then
	  errorExit "The port \""$CHECK_PORT"\"was blocked by: "$psname " with ID(s):"$psid
	fi
}

# Docker login
function docker_login () {
    echo -e "Docker login"

    if [ ! -z "${DOCKER_REG}" ]; then
        # Make sure credentials are set
        if [ -z "${DOCKER_USR}" ] || [ -z "${DOCKER_PSW}" ]; then
            errorExit "Docker credentials not set (DOCKER_USR and DOCKER_PSW)"
        fi

        docker login ${DOCKER_REG} -u ${DOCKER_USR} -p ${DOCKER_PSW} || errorExit "Docker login to ${DOCKER_REG} failed"
    else
        echo "Docker registry not set. Skipping"
    fi
}


#检查系统端口是否被占用，如果未被占用则返回空，否则返回占用信息
function port_check()
{
	CHECK_PORT=$1
	psname=`lsof -i:${CHECK_PORT}|awk '{print $1}'`
	psid=`lsof -i:$CHECK_PORT|awk '{print $2}'`
	if [ ! -n "$psname" ]; then
		return 0
	else
	  echo "The port \""$CHECK_PORT"\"was blocked by: "$psname " with ID(s):"$psid
	  exit 1
	fi	
	
}

# unzip the file and check the packages.
function prepare_env()
{
	echo "unzip file and check the war, jar"
	# .zip File Check
	if [ ! -d ${ZIP_FILENAME} ]; then
		echo "No directory ${ZIP_FILENAME}"
		if [ -f ${ZIP_FILENAME}.zip ]; then
			unzip -o ${ZIP_FILENAME}.zip
		else
			echo "Error: zip file is missing."
			exit 1
		fi
	else
		rm -rf ${ZIP_FILENAME}
		unzip -o ${ZIP_FILENAME}
	fi

	# .war File Check
	if [ ! -f ${WAR_FILENAME} ]; then
		echo "war file [${WAR_FILENAME}] is missing."
		exit 1
	fi
}
function clean_env()
{
	echo "clean env"
	docker_id=$(docker ps -a | grep $DOCKER_IMAGE_NAME | awk -F " " '{print $1}')
	while [ x$docker_id != x ]; do
		docker stop $docker_id
		docker rm $docker_id
		docker rmi $DOCKER_IMAGE_NAME
		docker_id=$(docker ps -a | grep $DOCKER_IMAGE_NAME | awk -F " " '{print $1}')
	done;
}

function create_image()
{
	echo "create_image"
	docker build -t ${DOCKER_REG}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VER} . || errorExit "Building ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VER} failed. Please check your local environment."
}

function run_docker()
{
	echo "run_docker"
	docker run --name $DOCKER_IMAGE_NAME -p $DOCKER_IMAGE_PORT:8080 ${DOCKER_REG}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VER}
}
function stop_docker()
{
	echo "Stop Docker"
	docker_id=$(docker ps -a | grep $DOCKER_IMAGE_NAME | awk -F " " '{print $1}')
	docker stop ${docker_id}
	docker rm ${docker_id}
	docker rmi ${DOCKER_REG}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VER} 
}

function docker_push()
{
	echo "Push docker image to registry"
	docker push ${DOCKER_REG}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VER} || errorExit "Pushing ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VER} failed"

}

function usage()
{
    cat << END_USAGE

${SCRIPT_NAME} - Script for building the Docker Image for JAVA web application.

Usage: ./${SCRIPT_NAME} <options>

--name              : [optional] The Docker image name, default: ${DOCKER_IMAGE_NAME}
--port              : [optional] The port for website, default: ${DOCKER_IMAGE_PORT}
--ver               : [optional] The version of docker image, default: ${DOCKER_IMAGE_VER}
--zip               : [optional] The static files for website, default: ${ZIP_FILENAME}
--war               : [optional] The war file for website, default: ${WAR_FILENAME}
--sync              : [optional] sync the docker to registry, default: ${SYNC_IMG}
--clean             : [optional] Clean the auto integrated docker environment, default: ${DOCKER_IMAGE_CLEAN}
--run               : [optional] Build & run docker environment, default: ${DOCKER_IMAGE_RUN}
--user              : [optional] The username for registry, default: ${DOCKER_USR}
--pwd               : [optional] The password for registry, default: ${DOCKER_PSW}

-h | --help         : Show this usage

END_USAGE

    exit 1
}
function processOptions()
{
    while [[ $# > 0 ]]; do
        case "$1" in
        	--sync)
                SYNC_IMG="true"; shift
            ;;
            --clean)
				DOCKER_IMAGE_CLEAN="true"; shift
			;;
			--run)
				DOCKER_IMAGE_RUN="true"; shift
			;;
			--push)
				DOCKER_PUSH="true"; shift
			;;
            --name)
                DOCKER_IMAGE_NAME=${2}; shift 2
            ;;
            --port)
				DOCKER_IMAGE_PORT=${2}; shift 2
            ;;
            --ver)
				DOCKER_IMAGE_VER=${2}; shift 2
			;;
			--zip)
				ZIP_FILENAME=${2}; shift 2
			;;
			--war)
				WAR_FILENAME=${2}; shift 2
			;;
			--user)
				DOCKER_USR=$(2); shift 2
			;;
			--pwd)
				DOCKER_PSW=$(2); shift 2
			;;
            -h | --help)
                usage
            ;;
            # *)
            #     usage
            # ;;
        esac
    done
}

function main()
{
	echo "main function"

	echo "SYNC_IMG = $SYNC_IMG"
	echo "DOCKER_IMAGE_NAME = $DOCKER_IMAGE_NAME"
	echo "DOCKER_IMAGE_VER = $DOCKER_IMAGE_VER"
	echo "DOCKER_IMAGE_PORT = $DOCKER_IMAGE_PORT"
	echo "DOCKER_IMAGE_CLEAN = $DOCKER_IMAGE_CLEAN"
	echo "DOCKER_IMAGE_RUN = $DOCKER_IMAGE_RUN"
	echo "ZIP_FILENAME = $ZIP_FILENAME"
	echo "WAR_FILENAME = $WAR_FILENAME"
	echo "PWD = $(pwd)"


	if [ "${DOCKER_PUSH}" == "true" ]; then
        # Attempt docker login
        echo "\nPush docker image to registry"
        prepare_env
		clean_env
		create_image
		
        docker_login
        docker_push

        exit 0
    fi
	
	if [ ${DOCKER_IMAGE_CLEAN} = "false" ]; then
		echo "Build & Run docker environment"
		port_check ${DOCKER_IMAGE_PORT}
		prepare_env
		clean_env
		create_image
		run_docker
	fi
	if [ ${DOCKER_IMAGE_RUN} = "false" ]; then
		echo "Clean docker environment"
		stop_docker
		clean_env
	fi


}

processOptions $*
main
