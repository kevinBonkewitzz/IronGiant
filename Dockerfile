FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["IronGiant/IronGiant.csproj", "IronGiant/"]
RUN dotnet restore "IronGiant/IronGiant.csproj"
COPY . .
WORKDIR "/src/IronGiant"
RUN dotnet build "IronGiant.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "IronGiant.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "IronGiant.dll"]
