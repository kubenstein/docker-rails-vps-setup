#
# This is Dockerfile for db-backup image.
# 
#

FROM debian:wheezy

RUN apt-get -qq update \
 && apt-get install -y curl

ADD s3-uploader.sh ./
ADD init.sh ./

RUN chmod +x s3-uploader.sh \
 && chmod +x init.sh

CMD ["./init.sh"]