# frozen_string_literal: true

# Main APP
require_relative './lib/fudo_challenge'
# Middlewares
require_relative './lib/middlewares/gzip'
require_relative './lib/middlewares/cors'

use Middlewares::Gzip
use Middlewares::Cors

run FudoChallenge.new
