# Quarterback 

## Backend Server

```sh
    ## PROD
    # Run both app and database
    docker-compose up -d  

    ## DEV
    # Run both app and database
    docker-compose -f docker-compose.dev.yml up -d  
    # Run database only
    docker-compose -f docker-compose.dev.yml up database
    # Re-build database
    docker-compose -f docker-compose.dev.yml up --build database

```

## API

Build proto files for API:

```sh
    make gopb
```

Build API binary
```sh
    make goapi_linux
    # Or
    make goapi_macos
```

Run API binary
```sh
    ./bin/api/bin
```

### Development

```sh
    cd api
    cp .env.example .env
    go run main.go
```