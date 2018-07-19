FROM centos:7
RUN yum update -y
RUN yum install -y \
automake \
dnsmasq \
ebtables \
iproute \
gcc \
gcc-c++ \
make \
zlib-devel \
glib2-devel \
gettext-devel \
git \
openssh-server \
pixman-devel

RUN git clone -b qemu-lite-v2.9.0 https://github.com/clearcontainers/qemu.git /qemu
WORKDIR /qemu
RUN git submodule update --init pixman
RUN ./configure --target-list=x86_64-softmmu --enable-vhost-net --enable-kvm
RUN make -j
RUN make install
WORKDIR /
RUN rm -rf /qemu

# password-less root ssh login
RUN /usr/bin/ssh-keygen -A
RUN mkdir /var/run/sshd
RUN passwd root -d
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/StrictModes yes/StrictModes no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
#RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo 'AuthorizedKeysFile /dev/null' >> /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
EXPOSE 1234

COPY start.sh /root/start.sh
COPY launch.sh /root/launch.sh
ENTRYPOINT ["/root/start.sh"]
