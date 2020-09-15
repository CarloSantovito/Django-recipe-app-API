FROM python:3.7-alpine
MAINTAINER Carlo Santovito

#Option to avoid some problem in python with docker image
ENV PYTHONUNBUFFERED 1

#Copy the local requirements file to image
COPY ./requirements.txt /requirements.txt
#Run the pip installa command with requirements file
RUN pip install -r /requirements.txt

#Create directory app
RUN mkdir /app
#Set work directory
WORKDIR /app
#Copy the content of local app directory to app directory of the image
COPY ./app /app

#Create user for security reason instead to use root access (as standard)
RUN adduser -D user
#Set the active user as "user"
USER user