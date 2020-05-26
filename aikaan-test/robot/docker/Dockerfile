FROM ubuntu
RUN apt-get update && apt-get install -y python python-pip firefox
RUN pip install webdrivermanager robotframework robotframework-seleniumlibrary RESTinstance
RUN webdrivermanager firefox --linkpath /usr/bin/
COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

