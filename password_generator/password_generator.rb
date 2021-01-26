#!/usr/bin/ruby

require_relative 'string'
require_relative 'error_checker'

class PasswordGenerator
  include ErrorChecker

  def initialize(num_arguments, length, options)
    return unless check_usage(num_arguments, length, options)

    @length = length.to_i
    @char_dictionary = {
      'u': Array('A'..'Z'),
      'l': Array('a'..'z'),
      'd': Array('0'..'9'),
      's': ("!#$%&()*+,-./:;<=>?@[\]^_`{|}~".split(//))}
    @password_output = Array[]
    @sorted_options = Hash.new
    @empty_options = Hash.new

    build_instance_variables(options)
  end

  def print_password
    puts @password_output.join("")
  end

  private

  def build_instance_variables(options)
    sort_options(options)
    build_empty_options
    merge_empty
    generate_password
  end

  def generate_password
    return unless check_valid_length

    @sorted_options.each do |key, value|
      generate_random(@char_dictionary[key.to_sym], value)
    end
    shuffle_password
  end

  def sort_options(options)
    while options != ""
      sliced_item = options.slice!(/.\d*/)
      @sorted_options[sliced_item[0]] = sliced_item.slice!(/\d+/)
    end
    clean_options
  end

  def build_empty_options
    remove_empty_keys
    fill_empty_options(@length - sum_options)
  end

  def remove_empty_keys
    @sorted_options.each do |key, value| 
      if value == 0
        @empty_options[key] = value
        @sorted_options.delete(key)
      end
    end
  end

  def fill_empty_options(number_remaining)
    return unless @empty_options.length > 0
  
    while number_remaining > 0
      @empty_options.each do |key, value|
        @empty_options[key] += 1
        number_remaining -= 1
        break if number_remaining == 0
      end
    end
  end

  def check_valid_length
    if sum_options > @length || empty_option
      length_mismatch_error
    end
    true
  end

  def empty_option
    @sorted_options.each do |key, value|
        return true if value == 0
    end
    false
  end

  def merge_empty
    @sorted_options = @sorted_options.merge(@empty_options)
  end

  def sum_options
    @sorted_options.sum { |key, value| value }
  end

  def clean_options
    @sorted_options.each do |key, value|
      @sorted_options[key] = 0 if value.nil?
      @sorted_options[key] = value.to_i
    end
  end

  def shuffle_password
    @password_output = @password_output.flatten.shuffle
  end

  def generate_random(type, count)
    return unless type.kind_of?(Array) && count > 0

    count.times do
      index = rand((type.length - 1))
      @password_output.push(type[index])
    end
  end
end

if __FILE__ == $0
  password_generator = PasswordGenerator.new(ARGV.length, ARGV[0], ARGV[1].dup)
  password_generator.print_password
end
