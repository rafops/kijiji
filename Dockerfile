FROM ruby:2.4
COPY . /root/kijiji
COPY ./config.yml.dist /root/kijiji/config.yml
WORKDIR /root/kijiji
RUN bundle
ENTRYPOINT ["/bin/sh", "./run.sh"]
