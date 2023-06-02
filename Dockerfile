FROM python:2.7-buster
MAINTAINER dine (dine@gmail.com)

# copy the source code of the API in "/" path
ADD student_age.py /

# update and install dependences: python-dev, flasks, etc
RUN apt update -y && apt install python-dev python3-dev libsasl2-dev python-dev libldap2-dev libssl-dev -y
RUN pip install flask==1.1.2 flask_httpauth==4.1.0 flask_simpleldap python-dotenv==0.14.0

# mount a volume to save data application (simple_api/student_age.json)
VOLUME ["/data"]

# port to expose the API
EXPOSE 5000

# command that will be always executed when the container starts : run the python app (with the script added on /data) 
CMD [ "python", "./student_age.py" ]
