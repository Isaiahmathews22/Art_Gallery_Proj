#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Art_Gallery_Proj.csproj", "."]
RUN dotnet restore "./Art_Gallery_Proj.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Art_Gallery_Proj.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Art_Gallery_Proj.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Art_Gallery_Proj.dll"]