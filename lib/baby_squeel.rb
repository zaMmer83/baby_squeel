# frozen_string_literal: true

require "active_record"
require_relative "baby_squeel/version"
require_relative "baby_squeel/query"
require_relative "baby_squeel/association"

module BabySqueel
  module Extension
    def query(&block)
      Query.new(all)._evaluate(&block)
    end
  end
end
