FROM hashicorp/terraform:latest

RUN apk add gcc musl-dev openssh sshpass rsync git python3 py3-pip py3-virtualenv