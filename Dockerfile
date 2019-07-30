FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
ENV NODE_VERSION 10.16.0
ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
ENV NODE_DOWNLOAD_SHA 2e2cddf805112bd0b5769290bf2d1bc4bdd55ee44327e826fa94c459835a9d9a
RUN curl -SL "$NODE_DOWNLOAD_URL" --output nodejs.tar.gz \
    && echo "$NODE_DOWNLOAD_SHA nodejs.tar.gz" | sha256sum -c - \
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

#ENV NODE_VERSION 6.11.3
#ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
#ENV NODE_DOWNLOAD_SHA 610705D45EB2846A9E10690678A078D9159E5F941487ACA20C6F53B33104358C


FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["Vue2Spa.csproj", ""]
RUN dotnet restore
COPY . .
WORKDIR "/src/"
RUN dotnet build "Vue2Spa.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Vue2Spa.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Vue2Spa.dll"]


