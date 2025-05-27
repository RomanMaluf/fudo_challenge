# Fudo Backend Challenge

## Requirements
- Ruby 3.x
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

