FROM python:2.7

WORKDIR /usr/src/app

ARG timezone=Etc/UTC
RUN echo $timezone > /etc/timezone \
    && ln -sfn /usr/share/zoneinfo/$timezone /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN cd /tmp && wget "http://pgoapi.com/pgoencrypt.tar.gz" \
    && tar zxvf pgoencrypt.tar.gz \
    && cd pgoencrypt/src \
    && make \
    && mv libencrypt.so /usr/local/lib/ \
    && cd /tmp \
    && rm -rf /tmp/pgoencrypt*

COPY requirements.txt /usr/src/app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

ENTRYPOINT ["python", "pokecli.py"]
