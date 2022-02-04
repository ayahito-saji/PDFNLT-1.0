FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# install php5.6
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common git && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y php5.6 php5.6-pspell php5.6-xml php5.6-mbstring aspell aspell-en

# download PDFNLT-1.0
RUN git clone https://github.com/KMCS-NII/PDFNLT-1.0 /PDFNLT-1.0

# install requirements
WORKDIR /PDFNLT-1.0/pdfanalyzer/dist
RUN apt-get install -y libfontconfig1-dev libjpeg-dev libopenjp2-7-dev xfonts-scalable libleptonica-dev zip liblbfgs-dev imagemagick && \
    tar xJf poppler-0.52.0.tar.xz && \
    unzip pdffigures-20160622.zip && \
    tar xvfz crfsuite-0.12.tar.gz

# install poppler 0.52.0
WORKDIR /PDFNLT-1.0/pdfanalyzer/dist/poppler-0.52.0
RUN (gzip -dc ../poppler-0.52.0.patch.gz | patch -p1) && \
    ./configure --enable-xpdf-headers && \
    make && \
    make install

# install pdffigures 20160622
WORKDIR /PDFNLT-1.0/pdfanalyzer/dist/pdffigures-master
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    make DEBUG=0 && \
    cp pdffigures /usr/local/bin/

# install crfsuite 0.12
WORKDIR /PDFNLT-1.0/pdfanalyzer/dist/crfsuite-0.12
RUN ./configure && \
    make && \
    make install

# update training data and model
WORKDIR /PDFNLT-1.0/pdfanalyzer
RUN ldconfig && \
    tar xfz dist/sampledata.tgz && \
    mv sampledata/* . && \
    php pdfanalyze.php --command update_training --all && \
    php pdfanalyze.php --command update_model

# add utility shell to /usr/local/bin
COPY ./pdf2xhtml /usr/local/bin/
RUN chmod a+x /usr/local/bin/pdf2xhtml

WORKDIR /workspace

CMD pdf2xhtml
