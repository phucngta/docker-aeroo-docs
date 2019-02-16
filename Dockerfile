FROM ubuntu:18.04
MAINTAINER phucngta <phucngta@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git curl xvfb supervisor \
        openjdk-8-jre-headless \
        python3-uno python3-pip

RUN apt-get install -y --no-install-recommends libreoffice-writer libreoffice-calc

# Accept EULA for MS fonts
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections # Accept EULA for MS fonts

RUN apt-get install -y --no-install-recommends ttf-mscorefonts-installer
    # msttcorefonts fonts-cantarell

RUN curl -s https://raw.githubusercontent.com/hotice/webupd8/master/install-google-fonts | bash
#RUN apt-get install -y ubuntustudio-font-meta
COPY ./resources/segoeui/ /usr/share/fonts/truetype/segoeui/

RUN apt-get clean && apt-get autoclean && apt-get autoremove

RUN pip3 install jsonrpc2 daemonize request

RUN git clone https://github.com/aeroo/aeroo_docs.git /opt/aeroo_docs


EXPOSE 8989

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf