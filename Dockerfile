FROM debian:jessie AS builder

ARG DEBIAN_FRONTEND=noninteractive

ENV VERSION 3.1

RUN apt-get update -y && apt-get install -y \
    wget \
    apt-transport-https

# Add Microsoft repository key and feed
RUN wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb

# Install .NET SDK & Runtime
RUN apt-get update -y && apt-get install -y \
    aspnetcore-runtime-$VERSION \
    dotnet-sdk-$VERSION

RUN mkdir -p /var/dotnet/fSharpApp

WORKDIR /var/dotnet/fSharpApp

COPY . .

RUN dotnet publish -r linux-x64 -f hello-world --self-contained true


FROM debian:jessie AS Deployment

COPY --builder:/var/dotnet/fSharpApp/hello-world .

RUN ./hello-world