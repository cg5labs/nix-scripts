#!/bin/bash
# see: https://wiki.archlinux.org/index.php/Full_system_backup_with_rsync

PARAM=$1
DATE=$(date +%Y%m%d)
LOG="log/rsync-errors.$(hostname -s).${DATE}.log"

if [[ -z $PARAM ]]; then
  echo ""
  echo "usage:   $(basename $0) [target-path]"
  echo "note:    omit trailing / for target path for rsync"
  echo "example: $(basename $0) /mnt/usb/ibm-t500/20160612"
  echo ""
  echo "see ${LOG} for transfer errors"
  echo ""
else
  rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/usb","/media/*","/lost+found"} / ${PARAM} 2> ${LOG}
  echo "==> rsync transfer completed."
  echo ""
  echo "==> transfer error log follows ..."
  echo "==> logfile: ${LOG}"
  echo ""
  cat ${LOG}
  echo ""
fi
