FROM centos:7
MAINTAINER www.ctnrs.com
RUN yum install -y gcc gcc-c++ make \
    openssl-devel pcre-devel gd-devel \
    iproute net-tools telnet wget curl && \
    yum clean all && \
    rm -rf /var/cache/yum/*
RUN wget https://nginx.org/download/nginx-1.14.2.tar.gz && \
    tar zxf nginx-1.14.2.tar.gz && \
    cd nginx-1.14.2 && \
    ./configure --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_stub_status_module && make -j 4 && make install && \
    rm -rf /usr/local/nginx/html/* && \
    echo "ok" >> /usr/local/nginx/html/status.html && \
    cd / && rm -rf nginx-1.12.2* && \
    mkdir /wwwroot && \
    mkdir /usr/local/nginx/conf/vhosts
    # ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV PATH $PATH:/usr/local/nginx/sbin
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY vhosts-example.conf /usr/local/nginx/conf/vhosts/
COPY nginx /etc/logrotate.d/
WORKDIR /usr/local/nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
