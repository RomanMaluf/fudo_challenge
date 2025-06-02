# Fudo Backend Challenge

## Requirements
- Ruby 3.3.0
- Bundler

## Getting Started

```bash
bundle install
bundle exec rackup -o 0.0.0.0       
```

## on Docker

```bash
docker build -t fudo-api .
docker run -p 9292:9292 fudo-api 
```

### With compose

With `docker Compose up`, you can run the project, and also the Swagger UI, on port 8080 to see the API specifications.

