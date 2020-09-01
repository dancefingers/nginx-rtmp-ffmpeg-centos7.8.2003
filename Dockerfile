FROM centos:7.8.2003

LABEL author xnz <xnzsir@gmail.com>

ENV NGINX_VERSION 1.18.0
ENV NGINX_RTMP_VERSION 1.2.1
ENV FFMPEG_VERSION 2.8.15

# Mapping Port
EXPOSE 1935
EXPOSE 80
EXPOSE 443


# FFmpeg.  
# Install EPEL Release because the installation needs to use another REPO source
# Install Nux-Dextop source
# Install FFmpeg
RUN yum install -y epel-release --nogpgcheck \
	&& rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro \
	&& rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm \
	&& yum install ffmpeg ffmpeg-devel -y


# Nginx And Nginx-rtmp-module.
# Build dependencies
# Install wget
# Download nginx and nginx-rtmp-module
# Install nginx and nginx-rtmp-module
# Cleanup.
RUN yum -y install gcc gcc-c++ make zlib zlib-devel openssl openssl-devel pcre pcre-devel pkgconf pkgconfig \
	&& cd /tmp \
	&& mkdir -p ./data/nginx-rtmp-ffmpeg \
	&& cd ./data/nginx-rtmp-ffmpeg/ \
	&& yum -y install wget \
	&& wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
	&& wget https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz \
	&& tar -zxf nginx-${NGINX_VERSION}.tar.gz \
	&& tar -zxf v${NGINX_RTMP_VERSION}.tar.gz \
	&& cd nginx-${NGINX_VERSION}/ \
	&& ./configure --prefix=/usr/local/src/nginx  --add-module=../nginx-rtmp-module-${NGINX_RTMP_VERSION} --with-debug --with-http_ssl_module \
	&& make && make install \
	&& cd /usr/local/src/nginx \
	&& mkdir -p ./data/hls \
	&& mkdir certs \
	&& rm -rf /var/cache/* /tmp/* \
	&& yum -y remove gcc*


# COPY NGINX config and static files.
COPY nginx.conf /usr/local/src/nginx/conf
COPY static /usr/local/src/nginx/data/static

# COPY SSL CERT.
COPY certs /usr/local/src/nginx/certs

# Start Nginx.
ENTRYPOINT ["/usr/local/src/nginx/sbin/nginx","-g","daemon off;"]
CMD ["-c","/usr/local/src/nginx/conf/nginx.conf"]