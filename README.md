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

## Usage
### GET the amount per scheduled payment
- `curl localhost:3000/payment-amount`
- required parameters:
  - asking_price
  - down_payment
    - must be at least 5% of the first 500k plus 10% of any amount above 500k (50k on a 750k)
  - amortization_period
    - min 5 years maximum of 25 years
  - payment_schedule
    - weekly, bi-weekly or monthly

### GET the maximum mortgage that can be taken out
- `curl localhost:3000/mortgage-amount`
- required parameters:
  - payment_amount
  - payment_schedule
    - weekly, bi-weekly or monthly
  - mortization_period
    - min 5 years maximum of 25 years
- optional parameters:
  - down_payment
    - if included, it's value should be added to the maximum mortgage returned

### UPDATE the current interest rate
- `curl localhost:3000/interest-rate`
- required parameters:
  - interest_rate

