FROM phusion/passenger-ruby21
MAINTAINER Renmak "renmak@firmhouse.com" 

# Set correct environment variables.
ENV HOME /root 

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"] 

ENV RAILS_ENV production 

RUN rm -f /etc/service/nginx/down 
RUN rm /etc/nginx/sites-enabled/default 
ADD nginx.conf /etc/nginx/sites-enabled/blog.conf 
ADD . /home/app/blog 

WORKDIR /home/app/blog

RUN chown -R app:app /home/app/blog
RUN sudo -u app bundle install --deployment 
RUN sudo -u app RAILS_ENV=production rake assets:precompile 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*