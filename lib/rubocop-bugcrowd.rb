# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/bugcrowd'
require_relative 'rubocop/bugcrowd/version'
require_relative 'rubocop/bugcrowd/inject'

RuboCop::Bugcrowd::Inject.defaults!

require_relative 'rubocop/cop/bugcrowd_cops'
