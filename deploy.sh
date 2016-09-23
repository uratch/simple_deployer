#!/bin/sh

# your setting
SSH_HOSTNAME=www.example.com
SSH_USERNAME=username
PROJECT=projectname
APP_ROOT=/var/www/${PROJECT}
DEPLOY_DST_DIR=/var/www/
LIMIT=30

FILE_PREFIX=${PROJECT}__
VERSION=`date +'%Y%m%d-%H%M%S'`

cd ${APP_ROOT}/.. &&
tar zcf /tmp/${PROJECT}.tar.gz $PROJECT &&
scp /tmp/${PROJECT}.tar.gz ${SSH_HOSTNAME}:/tmp &&
ssh ${SSH_USERNAME}@$SSH_HOSTNAME "cd /tmp && tar zxvf ${PROJECT}.tar.gz && mv $PROJECT $DEPLOY_DST_DIR$FILE_PREFIX$VERSION && ln -fsn $DEPLOY_DST_DIR$FILE_PREFIX$VERSION $APP_ROOT"

CNT=`ssh ${SSH_USERNAME}@$SSH_HOSTNAME "cd $DEPLOY_DST_DIR && ls -d ${FILE_PREFIX}* | wc -l"`

if test "$CNT" -ge $LIMIT ; then
    RM_NUM=`expr $CNT - $LIMIT`
    ssh $SSH_HOSTNAME "cd $DEPLOY_DST_DIR && ls -d ${FILE_PREFIX}* | sort | head -n $RM_NUM | xargs rm -rf "
fi
