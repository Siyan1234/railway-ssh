FROM Ubuntu:latest

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV GOOGLE_CHROME_BIN /usr/bin/google-chrome-stable
ENV GOOGLE_CHROME_DRIVER /usr/bin/chromedriver
ARG USER=root
USER $USER

RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i ./google-chrome-stable_current_amd64.deb; apt -fqqy install && \
    rm ./google-chrome-stable_current_amd64.deb

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

RUN apt-get update && apt-get -y install \
    python3 python3-dev python3-dev python3-pip python3-venv 

RUN pip3 install chromedriver-py

RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb

RUN apt-get install git curl python3-pip ffmpeg -y

RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ARG Ngrok
ARG Password
ARG re
ENV re=${re}
ENV Password=${Password}
ENV Ngrok=${Ngrok}
RUN apt install ssh wget unzip -y > /dev/null 2>&1
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip
RUN echo "./ngrok config add-authtoken ${Ngrok} &&" >>/1.sh
RUN echo "./ngrok tcp 22 --region ${re} &>/dev/null &" >>/1.sh
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/1.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:${Password}|chpasswd
RUN service ssh start
RUN chmod 755 /1.sh
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD  /1.sh
