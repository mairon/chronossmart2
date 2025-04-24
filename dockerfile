FROM ruby:2.3.8
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y vim-common
RUN apt-get install -y nodejs
RUN apt-get install -y wkhtmltopdf
RUN apt-get install -y openssl

ENV TZ="America/Asuncion"
RUN date


WORKDIR /smart
COPY vendor/gems/auditor-master /smart/vendor/gems/auditor-master
COPY Gemfile /smart/Gemfile
COPY Gemfile.lock /smart/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
#CMD ["rails", "server", "-b", "0.0.0.0"]
