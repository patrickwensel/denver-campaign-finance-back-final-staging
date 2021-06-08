#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["UserManagementApi/UserManagementApi.csproj", "UserManagementApi/"]
COPY ["UserManagementApi.DataCore/UserManagementApi.DataCore.csproj", "UserManagementApi.DataCore/"]
COPY ["Denver.DataAccess/Denver.DataAccess.csproj", "Denver.DataAccess/"]
COPY ["UserManagementApi.Domain/UserManagementApi.Domain.csproj", "UserManagementApi.Domain/"]
COPY ["Denver.EventBus/Denver.EventBus.csproj", "Denver.EventBus/"]
COPY ["Utility/Denver.Infra.csproj", "Utility/"]
RUN dotnet restore "UserManagementApi/UserManagementApi.csproj"
COPY . .
WORKDIR "/src/UserManagementApi"
RUN dotnet build "UserManagementApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "UserManagementApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "UserManagementApi.dll"]