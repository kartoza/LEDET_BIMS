#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
# Note this base image is based on debian
FROM kartoza/django-base
MAINTAINER Dimas Ciputra<dimas@kartoza.com>

RUN apt-get update -y && apt-get -y --force-yes install yui-compressor

COPY REQUIREMENTS.txt /REQUIREMENTS.txt
RUN pip install -r /REQUIREMENTS.txt
RUN pip install uwsgi

WORKDIR /home/web
RUN git init && git remote add origin https://github.com/kartoza/LEDET_BIMS.git
RUN git pull origin develop

#USER www-data
WORKDIR /home/web/django_project

RUN mkdir -p /home/web/media
ADD entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

ADD uwsgi.conf /uwsgi.conf

# Open port 8080 as we will be running our uwsgi socket on that
EXPOSE 8080

CMD ["uwsgi", "--ini", "/uwsgi.conf"]
