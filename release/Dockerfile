# TODO: freeze nginx version?
FROM	nginx:latest

# Add the compiled assets to the nginx html dir.
ADD     .mk_assets.tar.gz /tmp/assets/

# Move the config file to the proper place.
RUN     mv /tmp/assets/release/default.conf /etc/nginx/conf.d      && \
        mv /tmp/assets/static/index.html    /usr/share/nginx/html/ && \
        mv /tmp/assets/static               /usr/share/nginx/html/
