# README
## Running the Application
Clone the repository,
Run following commands:
- `bundle install` This installs the dependencies
- `bin/rails s` This runs the server
- `bin/rails db:create` Create the databases

## Installing with Docker Compose
- `docker-compose build` Build the images
- `docker-compose up` Start docker processes
- `docker-compose run web rails db:create` Create the databases

## View the homapage
- `curl 127.0.0.1:3000` Curl the homepage
