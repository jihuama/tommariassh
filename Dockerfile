FROM alpine

MAINTAINER Charles "jihua.ma@gmail.com"

ENV TZ Asia/Shanghai

RUN addgroup -S mysql \
    && adduser -S mysql -G mysql \
    && apk update \
    && apk upgrade \
    && apk add --no-cache bash \
        bash-doc \
        bash-completion \
        tzdata \
        openjdk8-jre \
        vim \
        mysql \
        mysql-client \
        openssh-server \
    && rm -rf /var/cache/apk/* \
    && awk '{ print } $1 ~ /\[mysqld\]/ && c == 0 { c = 1; print "skip-host-cache\nskip-name-resolve\nlower_case_table_names=1"}' /etc/my.cnf > /tmp/my.cnf \
    && mv /tmp/my.cnf /etc/my.cnf \
    && mkdir /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && chmod -R 777 /run/mysqld

RUN mkdir -p /var/run/sshd
RUN mkdir -p mkdir/root/.ssh/
# ssh remote login password is 123456
RUN echo "root:123456" | chpasswd 
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key
RUN wget http://mirrors.hust.edu.cn/apache/tomcat/tomcat-7/v7.0.93/bin/apache-tomcat-7.0.93.tar.gz && \
tar xvf apache-tomcat-7.0.93.tar.gz -C /usr/local && mv /usr/local/apache-tomcat-7.0.93 /usr/local/tomcat
RUN rm -f apache-tomcat-7.0.93.tar.gz
# Add Tomcat Manager Gui user & password
RUN echo '<tomcat-users> \
<role rolename="manager-gui"/> \
<role rolename="manager-script"/> \
<user username="tomcat" password="123456" roles="admin,manager-gui,manager-script,manager-status"/> \
</tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml
# Setup Timezone
RUN cp -fs /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone 

COPY startup.sh /root/startup.sh
RUN chmod a+x /root/startup.sh
    
EXPOSE 22 3306 8080

ENTRYPOINT /root/startup.sh
