#!/usr/bin/ruby

class UsageError < StandardError
  def initialize(msg)
    super(msg)
  end
end