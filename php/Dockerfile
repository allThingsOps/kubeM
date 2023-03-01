FROM ubuntu:20.04

ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY student.php /usr/src/myapp/student.php
WORKDIR /usr/src/myapp

# trunk-ignore(hadolint/DL3008)
RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
        php7.4 \
        apache2 \
		php7.4-mysql \
		php-pdo \
        php-json\
        php7.4-cli \
		php-redis \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
CMD [ "php", "student.php" ]

