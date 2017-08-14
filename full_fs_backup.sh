#!/bin/bash
# see: https://wiki.archlinux.org/index.php/Full_system_backup_with_rsync

# vars
PARAM=$1
DATE=$(date +%Y%m%d)
LOG_PATH="log"
LOG="${LOG_PATH}/rsync-errors.$(hostname -s).${DATE}.log"
RC=0

# check for log path
if [[ ! -d ${LOG_PATH} ]]; then
  mkdir -pv ${LOG_PATH}
  RC=$?
fi

if [[ -z $PARAM ]]; then
  echo ""
  echo "usage:   $(basename $0) [target-path]"
  echo "note:    omit trailing / for target path for rsync"
  echo "example: $(basename $0) /mnt/usb/ibm-t500/20160612"
  echo ""
  echo "see ${LOG} for transfer errors"
  echo ""
  RC=1
fi

if [[ $RC -eq 0 ]]; then
  rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/usb","/media/*","/lost+found"} / ${PARAM} 2> ${LOG}
  RC=$?
  echo "==> rsync transfer completed."
  echo ""
  if [[ $RC -ne 0 ]]; then 
    echo "==> transfer error log follows ..."
    echo "==> logfile: ${LOG}"
    echo ""
    cat ${LOG}
    echo ""
  fi
fi

exit ${RC}
