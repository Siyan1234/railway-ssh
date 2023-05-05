FROM ghcr.io/ashwinstr/ux-venom-docker:latest

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

ENV DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AbUR2VPBcp3aDTPvU96g6IGjRx-pkSxh8b5YCj4kWFaHaXtFctxTywLyShecQ_WpAB9QoQ" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)

RUN apt-get install git curl python3-pip ffmpeg -y

# Cloning-Repo
RUN git clone https://github.com/DarkSickXD/yashhelp

# Setting up Working Directory
WORKDIR yashhelp

RUN python3 -m pip install --upgrade pip wheel setuptools &&\
    python3 -m pip install chromedriver-py


# Start
CMD ["sh","start"]
