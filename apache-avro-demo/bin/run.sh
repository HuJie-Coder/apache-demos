#!/bin/bash

# Usage: bash run.sh start|stop
MAIN_CLASS="com.jaydenjhu.custom.Application"
JAVA_ARGS=""
HEAP_MAX_MEMORY="${HEAP_MAX_MEMORY-1m}"
HEAP_INIT_MEMORY="${HEAP_MAX_MEMORY}"
OPERATION=${1-start}
WEDATA_PROFILES_ACTIVE=${WEDATA_PROFILES_ACTIVE}

function log_debug(){
  if [[ $LOG_LEVEL_NUM -ge 3 ]];then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] ${*}"
  fi
}

function log_info(){
  if [[ $LOG_LEVEL_NUM -ge 2 ]];then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] ${*}"
  fi
}

function log_error(){
  if [[ $LOG_LEVEL_NUM -ge 1 ]];then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] ${*}"
  fi
}

function generate_log_level(){
  case "${LOG_LEVEL}" in
    "debug")
        LOG_LEVEL_NUM=3
      ;;
    "info")
        LOG_LEVEL_NUM=2
      ;;
    "error")
        LOG_LEVEL_NUM=1
      ;;
    *)
        LOG_LEVEL_NUM=1
    esac
}

function init_env(){
  LIB_PATH=${CURRENT_PATH}/lib
  BIN_PATH=${CURRENT_PATH}/bin
  CONF_PATH=${CURRENT_PATH}/config
  DATA_PATH=${CURRENT_PATH}/data
  LOG_PATH=${CURRENT_PATH}/log
  PID_FILE=${CURRENT_PATH}/pid

  generate_log_level
  generate_application_properties

  log_info "CURRENT_DIR: ${CURRENT_PATH}"
  log_info "LIB_PATH: ${LIB_PATH}"
  log_info "BIN_PATH: ${BIN_PATH}"
  log_info "LOG_PATH: ${LOG_PATH}"
  log_info "CONF_PATH: ${CONF_PATH}"
  log_info "DATA_PATH: ${DATA_PATH}"
  log_debug "CLASSPATH: ${CLASS_PATH}"
  log_debug "APPLICATION_PROPERTIES:${APPLICATION_PROPERTIES}"

  if [[ ! -d ${LOG_PATH}  ]];then
    mkdir -p ${LOG_PATH}
  fi
}

function generate_application_properties(){
  # add jars to classpath
  jars=`ls ${LIB_PATH}`
  for jarfile in ${jars}
  do
    jarfile=${LIB_PATH}/${jarfile}
    log_debug "add jar: ${jarfile}"
    CLASS_PATH="${CLASS_PATH}:${jarfile}"
  done


  CLASS_PATH=${CLASS_PATH:1}
  JVM_PROPERTIES="
                -Xms${HEAP_INIT_MEMORY}
                -Xmx${HEAP_MAX_MEMORY}
                -Xloggc:${LOG_PATH}/gc.log
                -server
                -XX:+UseParallelGC
                -XX:+PrintGC
                -XX:+PrintGCDetails
                -XX:+HeapDumpOnOutOfMemoryError
                -XX:OnOutOfMemoryError=\"echo test\"
                -XX:ErrorFile=${LOG_PATH}/java_error.log
                -XX:HeapDumpPath=${LOG_PATH}/dump.hprof
                -Dfile.encoding=utf-8"
  SPRING_PROPERTIES="--spring.profiles.active=${WEDATA_PROFILES_ACTIVE}"
}

function start_application(){
  log_info "application env is ${WEDATA_PROFILES_ACTIVE}"
  JAVA_COMMAND="java ${JVM_PROPERTIES} -cp ${CLASS_PATH} ${MAIN_CLASS} ${SPRING_PROPERTIES} ${JAVA_ARGS}"
  log_info "${JAVA_COMMAND}"
  cd ${CURRENT_PATH}
  ${JAVA_COMMAND} 2>${LOG_PATH}/error.log &
  APPLICATION_PID=${!}
  echo "${APPLICATION_PID}" > ${PID_FILE}
  log_info "application pid:${APPLICATION_PID}"
}

function stop_application() {
  APPLICATION_PID=`cat ${PID_FILE}`
  if [[ ! -z ${APPLICATION_PID} ]]; then
    local pid_exists=`ps -ef | awk '{print $2}' | grep ${APPLICATION_PID}`
    if [[ -z ${pid_exists} ]];then
      log_error "pid: ${APPLICATION_PID} doesn't exists,please check manually!"
    else
      log_info "start stop application..."
      kill ${APPLICATION_PID}
      log_info "application has been stopped!"
    fi
  else
    log_error "pid is blank,please check manually!"
  fi
}

function status_application(){
    APPLICATION_PID=`cat ${PID_FILE}`
    if [[ ! -z ${APPLICATION_PID} ]]; then
      local pid_exists=`ps -ef | awk '{print $2}' | grep ${APPLICATION_PID}`
      if [[ -z ${pid_exists} ]];then
        log_error "pid: ${APPLICATION_PID} doesn't exists"
        log_info "status: [Inactive]"
      else
        log_info "pid: ${APPLICATION_PID}"
        log_info "status: [Active]"
      fi
    else
      log_error "pid is blank,please check manually!"
    fi
}

function main() {
    init_env
    case ${OPERATION} in
    "start")
        start_application
      ;;
    "stop")
        stop_application
      ;;
    "status")
        status_application
    esac
}

export LANG=zh_CN.UTF-8
CURRENT_PATH=$(dirname $(dirname $0))
LOG_LEVEL="info"
main
