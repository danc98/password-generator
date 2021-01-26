#!/usr/bin/ruby

require_relative 'string'
require_relative 'usage_error'

module ErrorChecker
  def check_usage(num_arguments, password_length, password_options)
    if num_arguments == 0
      no_argument_error
    elsif num_arguments == 1
      if password_length == "-u" || password_length == "-usage"
        print_usage
        return false
      else
        no_options_error
      end
    elsif num_arguments > 2
      argument_excess_error
    end

    unless password_length.is_int?
      length_type_error
    end

    unless check_valid_option(password_options.split(''))
      valid_option_error
    end
    
    true
  end

  private

  def print_usage
    puts <<-END_USAGE 
    Usage: ruby password_generator.rb \"length\" \"u(#)\"
    Type:
         u: Uppercase
         l: Lowercase
         d: Digits
         s: Special Characters
         #: Number of each type in password. (OPTIONAL)
    Example: ruby password_generator.rb 7 u3l4
    Generates 7 length password with 3 uppercase and 4 lowercase.
    Example: ruby password_generator.rb 12 ls10
    Generates 8 length password with lowercase and 10 special.
    END_USAGE
    raise UsageError.new("Unable to generate password.")
  end

  def no_argument_error
    puts "Invalid usage."
    puts "Use \"-u\" or \"-usage\""
    raise UsageError.new("No arguments error.")
  end

  def argument_excess_error
    puts "ERROR: Too many arguments."
    puts "Use \"-u\" or \"-usage\""
    raise UsageError.new("Excess arguments error.")
  end

  def length_type_error
    puts "ERROR: Length must be integer."
    puts "Use \"-u\" or \"-usage\""
    raise UsageError.new("Length type error.")
  end

  def no_options_error
    puts "ERROR: No options given."
    puts "Use \"-u\" or \"-usage\""
    raise UsageError.new("No options error.")
  end

  def valid_option_error
    puts "ERROR: Invalid password options."
    puts "Use \"-u\" or \"-usage\""
    raise UsageError.new("Invalid options error.")
  end

  def length_mismatch_error
    puts "ERROR: Length not valid for given options!"
    puts "Use \"-u\" or \"-usage\""
    raise UsageError.new("Improper length error.")
  end
  
  def check_valid_option(password_option)
    return false if password_option[0].is_int?

    password_option.each do |n|
      unless n.is_int? || n =~ /[dlsu]/
        return false
      end
    end
    true
  end
end