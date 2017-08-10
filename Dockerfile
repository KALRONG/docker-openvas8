# OpenVAS 8
# Based on:  mikesplain openvas docker image

FROM  debian
MAINTAINER  KALRONG <xrb@kalrong.net>

RUN  apt-get update; apt-get -y upgrade; apt-get -y dist-upgrade
RUN  apt-get install build-essential \
		    redis-server \
                    bison \
                    flex \
                    cmake \
                    rpm \
                    alien \
                    nsis \
                    pkg-config \
                    libglib2.0-dev \
                    libgnutls28-dev \
                    libpcap0.8-dev \
                    libgpgme11 \
                    libgpgme11-dev \
                    openssh-client \
                    doxygen \
                    libuuid1 \
                    uuid-dev \
                    sqlfairy \
                    xmltoman \
                    sqlite3 \
                    libsqlite3-dev \
                    libsqlite3-tcl \
                    libxml2-dev \
                    libxslt1.1 \
                    libxslt1-dev \
                    libcurl4-gnutls-dev \
                    libkrb5-dev \
                    xsltproc \
                    libmicrohttpd-dev \
                    wget \
                    rsync \
                    texlive-latex-base \
                    texlive-latex-recommended \
                    texlive-latex-extra \
                    unzip \
                    wapiti \
                    nmap \
		    libssh-dev \
      	            libhiredis-dev \
		    libgcrypt-dev \
                    -y --no-install-recommends
RUN  mkdir /openvas-src && \
RUN  cd /openvas-src && \
        wget http://wald.intevation.org/frs/download.php/2433/openvas-libraries-8.0.9.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2436/openvas-scanner-5.0.8.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2445/openvas-manager-6.0.11.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2442/greenbone-security-assistant-6.0.12.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2397/openvas-cli-1.4.5.tar.gz
RUN  cd /openvas-src/ && \
        tar zxvf openvas-libraries-8.0.9.tar.gz && \
        tar zxvf openvas-scanner-5.0.8.tar.gz && \
        tar zxvf openvas-manager-6.0.11.tar.gz && \
        tar zxvf greenbone-security-assistant-6.0.12.tar.gz && \
        tar zxvf openvas-cli-1.4.5.tar.gz && \
RUN  cd /openvas-src/openvas-libraries-8.0.9 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install
RUN  cd /openvas-src/openvas-scanner-5.0.8 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install
RUN  cd /openvas-src/openvas-manager-6.0.11 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install
RUN  cd /openvas-src/greenbone-security-assistant-6.0.12 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install
RUN  cd /openvas-src/openvas-cli-1.4.5 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install
RUN  rm -rf /openvas-src
RUN  mkdir /dirb
RUN  cd /dirb && \
     wget http://downloads.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz && \
     tar -zxvf dirb222.tar.gz && \
     cd dirb222 && \
     chmod 700 -R * && \
     ./configure && \
     make && \
     make install && \
RUN  cd /tmp && \
     wget https://github.com/Arachni/arachni/releases/download/v1.2.1/arachni-1.2.1-0.5.7.1-linux-x86_64.tar.gz && \
     tar -zxvf arachni-1.2.1-0.5.7.1-linux-x86_64.tar.gz && \
     mv arachni-1.2.1-0.5.7.1 /opt/arachni && \
     ln -s /opt/arachni/bin/* /usr/local/bin/ && \
RUN  wget https://github.com/sullo/nikto/archive/master.zip && \
     unzip master.zip -d /tmp && \
     mv /tmp/nikto-master/program /opt/nikto && \
     rm -rf /tmp/nikto-master && \
     echo "EXECDIR=/opt/nikto\nPLUGINDIR=/opt/nikto/plugins\nDBDIR=/opt/nikto/databases\nTEMPLATEDIR=/opt/nikto/templates\nDOCDIR=/opt/nikto/docs" >> /opt/nikto/nikto.conf && \
     ln -s /opt/nikto/nikto.pl /usr/local/bin/nikto.pl && \
     ln -s /opt/nikto/nikto.conf /etc/nikto.conf && \
RUN  mkdir -p /openvas && \
     wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate -O /openvas/openvas-check-setup && \
     chmod a+x /openvas/openvas-check-setup && \
RUN  apt-get purge -y --auto-remove build-essential cmake

ADD  bin/* /openvas/
ADD  config/* /etc/redis/
RUN  chmod 700 /openvas/*.sh && \
     bash /openvas/setup.sh

CMD  bash /openvas/start.sh

# Expose UI
EXPOSE 443 9390 9391 9392
