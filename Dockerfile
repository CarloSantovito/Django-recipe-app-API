FROM python:3.7-alpine
MAINTAINER Carlo Santovito

#Option to avoid some problem in python with docker image
ENV PYTHONUNBUFFERED 1

#Copy the local requirements file to image
COPY ./requirements.txt /requirements.txt
#Use the package manager in alpine (apk) to install postgres-client
RUN apk add --update --no-cache postgresql-client jpeg-dev
#Install some additional packages. The virtual options and his name (.tmp-build-deps) it's an alias
#to facilitate the remove the installation of this additional packages
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
#Run the pip installa command with requirements file
RUN pip install -r /requirements.txt
#Delete the temporary requirements installed before
RUN apk del .tmp-build-deps

#Create directory app
RUN mkdir /app
#Set work directory
WORKDIR /app
#Copy the content of local app directory to app directory of the image
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
#Create user for security reason instead to use root access (as standard)
RUN adduser -D user
#Give ownership of the directory vol to the user "user"
RUN chown -R user:user /vol/
#Permission to make everything with this directory and subs directory
RUN chmod -R 755 /vol/web
#Set the active user as "user"
USER user