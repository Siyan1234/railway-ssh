FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV GOOGLE_CHROME_BIN /usr/bin/google-chrome-stable
ENV GOOGLE_CHROME_DRIVER /usr/bin/chromedriver
ARG USER=root
USER $USER
RUN apt update && apt upgrade -y
RUN apt install -y wget curl zip unzip git python3-pip
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get -y install \
tightvncserver \
expect \
xfonts-100dpi \
xfonts-75dpi \
xfonts-scalable \
xfonts-cyrillic \
tightvncserver \
fonts-ipafont-gothic && \
expect -c 'set timeout 3;spawn /usr/bin/vncpasswd;expect "*?assword:*";send -- "selenium\r";expect "*?erify:*";send -- "selenium\r";expect "*?view-only password*";send -- "n\r";send -- "\r";expect eof' && \
touch /root/.xsession && \
apt-get remove --purge -y expect && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
rm -rf /var/lib/apt/lists/*
RUN apt update && apt upgrade -y
RUN apt-get install keyboard-configuration -y
RUN apt-get update && apt-get -y install \
    python3 python3-dev python3-dev python3-pip
RUN apt install -y xfce4-goodies xfce4
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget -O /tmp/rarlinux.tar.gz http://www.rarlab.com/rar/rarlinux-x64-6.0.0.tar.gz && \
    tar -xzvf rarlinux.tar.gz && \
    cd rar && \
    cp -v rar unrar /usr/bin/ && \
    # clean up
    rm -rf /tmp/rar*

RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip  && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ && \
    # clean up the container "layer", after we are done
    rm /tmp/chromedriver.zip

ENV GOOGLE_CHROME_DRIVER /usr/bin/chromedriver
ENV GOOGLE_CHROME_BIN /usr/bin/google-chrome-stable


RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

RUN apt-get update && apt-get -y install \
    python3 python3-dev python3-dev python3-pip python3-venv 

RUN pip3 install chromedriver-py
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg && \
    install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list 
RUN apt-get install git curl python3-pip ffmpeg -y

RUN git clone https://github.com/vlakhani28/bbht.git
RUN chmod +x bbht/install.sh
RUN ./bbht/install.sh
RUN mv bbht/run-after-go.sh /root/tools
RUN chmod +x /root/tools/run-after-go.sh
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ARG ngrokid
ARG Password
ENV Password=${Password}
ENV ngrokid=${ngrokid}
RUN apt install -y xfce4 xfce4-goodies keyboard-configuration
RUN apt install -y tightvncserver
RUN apt install ssh wget unzip -y > /dev/null 2>&1
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip
RUN echo "./ngrok config add-authtoken ${ngrokid} &&" >>/1.sh
RUN echo "./ngrok tcp 22 &>/dev/null &" >>/1.sh
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/1.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:${Password}|chpasswd
RUN service ssh start
RUN chmod 755 /1.sh
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD  /1.sh
