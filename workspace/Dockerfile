FROM debian:latest

ARG USER_NAME=labuser
ARG USER_UID=1000
ARG USER_GID=1000

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

COPY packages*.txt /tmp

RUN apt update && \
    cat /tmp/packages*.txt | xargs apt install -y --no-install-recommends && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/packages*.txt

RUN echo 'LANG="C.UTF-8"' >> /etc/bash.bashrc && \
    echo 'LC_ALL="C.UTF-8"' >> /etc/bash.bashrc

RUN if ! getent group $USER_GID; then groupadd -g $USER_GID $USER_NAME; fi && \
    if ! getent passwd $USER_NAME; then useradd -ms /bin/bash -u $USER_UID -g $USER_GID $USER_NAME; fi && \
    usermod -aG sudo $USER_NAME && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME}


USER ${USER_NAME}
ENTRYPOINT ["/usr/bin/env", "bash"]
