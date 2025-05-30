# frozen_string_literal: true

# Main APP
require_relative './lib/fudo_challenge'
# Middlewares
require_relative './lib/middlewares/gzip'

use Middlewares::Gzip

run FudoChallenge.new
