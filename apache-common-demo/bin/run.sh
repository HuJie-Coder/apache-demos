#!/bin/bash

# Usage: run.sh start|restart|stop|status
# Creator: Jayden
MAIN_CLASS="com.jaydenjhu.custom.Application"
HEAP_MAX_MEMORY="${HEAP_MAX_MEMORY-1m}"
HEAP_INIT_MEMORY="${HEAP_MAX_MEMORY}"
OPERATION=${1-start}
SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE-prod}
JAVA_ARGS="--spring.profiles.active=${SPRING_PROFILES_ACTIVE}"
IS_DOCKER=${IS_DOCKER}

function log_debug(){
  if [[ $LOG_LEVEL_NUM -ge 4 ]];then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] ${*}"
  fi
}

function log_warn(){
  if [[ $LOG_LEVEL_NUM -ge 3 ]];then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [WARN] ${*}"
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
        LOG_LEVEL_NUM=4
      ;;
    "warn")
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

  log_debug "CURRENT_DIR: ${CURRENT_PATH}"
  log_debug "LIB_PATH: ${LIB_PATH}"
  log_debug "BIN_PATH: ${BIN_PATH}"
  log_debug "LOG_PATH: ${LOG_PATH}"
  log_debug "CONF_PATH: ${CONF_PATH}"
  log_debug "DATA_PATH: ${DATA_PATH}"
  log_debug "CLASSPATH: ${CLASS_PATH}"

  if [[ ! -d ${LOG_PATH}  ]];then
    mkdir -p ${LOG_PATH}
  fi
  if [[ ! -d ${CONF_PATH}  ]];then
    mkdir -p ${CONF_PATH}
  fi
  if [[ ! -d ${LIB_PATH}  ]];then
    mkdir -p ${LIB_PATH}
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
}

function start_application(){
  check_application_is_running
  local application_is_running=${?}
  if [[ ${application_is_running} == 1 ]];then
    log_error "application(PID=$(cat ${PID_FILE})) is already running"
  fi
  log_info "classpath:${CLASS_PATH}"
  log_info "main class:${MAIN_CLASS}"
  log_info "java args: ${JAVA_ARGS}"
  cd ${CURRENT_PATH} || exit
  java -Xms${HEAP_INIT_MEMORY} \
       -Xmx${HEAP_MAX_MEMORY} \
       -Xloggc:${LOG_PATH}/gc-%t.log \
       -server \
       -XX:+UseParallelGC \
       -XX:+PrintGC \
       -XX:+PrintGCDetails \
       -XX:+HeapDumpOnOutOfMemoryError \
       -XX:OnOutOfMemoryError="kill %p" \
       -XX:ErrorFile=${LOG_PATH}/java_error_%p.log \
       -XX:HeapDumpPath=${LOG_PATH} \
       -Dfile.encoding=utf-8 \
       -cp ${CLASS_PATH} \
       ${MAIN_CLASS} \
       ${JAVA_ARGS} 2>${LOG_PATH}/error.log &
  APPLICATION_PID=${!}
  echo "${APPLICATION_PID}" > ${PID_FILE}
  log_info "start success, pid:${APPLICATION_PID}"
}

# return 1 if application is alive else 0
function check_application_is_running() {
  if [[ -f ${PID_FILE} ]];then
      APPLICATION_PID=$(cat ${PID_FILE})
      if [[ ! -z ${APPLICATION_PID} ]]; then
        local pid_exists=$(ps -ef | awk '{print $2}' | grep ${APPLICATION_PID})
        if [[ ! -z ${pid_exists} ]];then
          return 1
        else return 0
        fi
      else return 0
      fi
    else return 0
  fi
}

function stop_application() {
  APPLICATION_PID=$(cat ${PID_FILE})
  if [[ ! -z ${APPLICATION_PID} ]]; then
    local pid_exists=$(ps -ef | awk '{print $2}' | grep ${APPLICATION_PID})
    if [[ -z ${pid_exists} ]];then
      log_warn "application(PID=${APPLICATION_PID}) is stopped"
    else
      log_info "start stop application(PID=${APPLICATION_PID})"
      kill ${APPLICATION_PID}
      wait ${APPLICATION_PID}
      log_info "stop success"
    fi
  else
    log_warn "can't find pid file,please type 'ps -ef | grep java' to find the pid and kill it"
  fi
}

function status_application(){
    APPLICATION_PID=$(cat ${PID_FILE})
    if [[ ! -z ${APPLICATION_PID} ]]; then
      local pid_exists=`ps -ef | awk '{print $2}' | grep ${APPLICATION_PID}`
      if [[ -z ${pid_exists} ]];then
        log_error "pid: ${APPLICATION_PID} doesn't exists"
        log_warn "status: [Inactive]"
      else
        log_info "pid: ${APPLICATION_PID}"
        log_info "status: [Active]"
      fi
    else
      log_warn "pid is blank,please check manually!"
    fi
}

function main() {
    init_env
    case ${OPERATION} in
    "start")
        start_application
        # 如果是 docker 的启动脚本，当容器关闭时，调用 stop_application 优雅关闭服务
        if [[ ${IS_DOCKER} = "true" ]];then
          trap stop_application EXIT
          tail -f /dev/null
        fi 
      ;;
    "stop")
        stop_application
      ;;
    "restart")
        stop_application
        start_application
      ;;
    "status")
        status_application
    esac
}

export LANG=zh_CN.UTF-8
CURRENT_PATH=$(pwd "$(dirname "$(dirname $0)")")
if [[ "${CURRENT_PATH##*/}" = "bin" ]];then
  CURRENT_PATH=$(dirname ${CURRENT_PATH})
fi
LOG_LEVEL="info"
main
