#Build an image that can run generator-gulp-angular
FROM ubuntu:latest
MAINTAINER Ajay Ganapathy <lets.talk@designbyajay.com>
RUN apt-get -yq update && apt-get -yq upgrade
#
# Install pre-requisites
RUN apt-get -yq install python-software-properties \
  software-properties-common \
  python \
  g++ \
  make \
  git \
  libfreetype6
#
# Install node.js, yo, gulp, bower, and generator-gulp-angular
RUN apt-get install -yq curl \
  && curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash - \
  && apt-get -yq install nodejs \
  && apt-get -yq update \
  && npm install -g yo \
  && npm update
#
# Add a yeoman user because yeoman doesn't like being root
RUN adduser --disabled-password --gecos "" --shell /bin/bash yeoman; \
  echo "yeoman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/yeoman
#
# set up a directory that will hold the files we sync from the host machine
RUN mkdir /home/yeoman/my-project-root \
  # set up a directory for global npm packages that does not require root access
  && mkdir /home/yeoman/.npm_global \
  && chmod -R 777 /home/yeoman
ENV NPM_CONFIG_PREFIX /home/yeoman/.npm_global
WORKDIR /home/yeoman/my-project-root
VOLUME /home/yeoman/my-project-root
#
#---------------------------------------------------
#You will need to uncomment the following line to expose the ports on which your generator serves web pages. For example, the gulp-angular generator serves webpages on ports 3000 and 3001, while other generators use port 9000.
#EXPOSE 3000-3001
#---------------------------------------------------
#
# drop to yeoman user and a bash shell
USER yeoman
CMD ["/bin/bash"]
