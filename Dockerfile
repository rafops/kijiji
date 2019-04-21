FROM ruby:2.6
RUN apt-get update \
      && apt-get install -y sqlite3 \
      && rm -rf /var/lib/apt/lists/*
RUN mkdir /root/workdir
COPY Gemfile* /root/workdir/
WORKDIR /root/workdir
RUN bundle
CMD ["/bin/sh", "./boot.sh"]
