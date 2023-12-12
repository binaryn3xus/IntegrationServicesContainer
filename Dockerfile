FROM mcr.microsoft.com/mssql/server:2019-latest
#FROM ubuntu:latest

USER root

RUN apt-get update && \
    apt-get install -y software-properties-common curl python3 libldap-common && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2022.list)"

RUN apt-get update
RUN apt-get install -y mssql-server-is

RUN echo "[TELEMETRY]\nenabled = F" > /var/opt/ssis/ssis.conf

RUN SSIS_PID=Express ACCEPT_EULA=Y /opt/ssis/bin/ssis-conf -n setup

RUN mkdir -p /home/mssql/.ssis/.system

RUN chmod -R 777 /home/mssql

RUN cp /root/.bashrc /home/mssql/.bashrc

RUN echo "\nexport PATH=/opt/ssis/bin:$PATH" > /home/mssql/.bashrc

USER mssql
