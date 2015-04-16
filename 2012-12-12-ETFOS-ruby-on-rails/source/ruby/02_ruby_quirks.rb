#!/usr/bin/env ruby

# Iteracije
# ---------
[1, 2, 3].each do |item|
  puts "#{item} => #{item**2}"
end

{ :one => 1, :two => 2, :three => "TRI" }.each do |key,value|
  puts "#{key} => #{value}"
end


# Symbols - Strings
# http://www.robertsosinski.com/2009/01/11/the-difference-between-ruby-symbols-and-strings/
-------------------
:vlado.object_id
"vlado".object_id

:vlado.object_id
"vlado".object_id
# object_id je identifikator objekta, isti pokazuje na isti objekt u memoriji.
# Kad god kreiramo novi String Ruby alocira memoriju za njega
# identitet (koristi symbol) nasuprot sadržaja (koristi simbol)
# Usporedba je puno brža

h = { :one => 1, "two" => 2 }
h[:one]
h["two"]
# :one je puno bolja opcija

# Sve je objekt
# -------------
# čak su i klase i brojevi objekti
class MyClass
  # something
end

# MyClass = Class.new do
#   # something
# end

3 + 2
3.class.instance_methods.sort
3.+ 2
3.send :+, 2

# Zapravo čak je i ništa objekt :)
nil.class
nil.class.instance_methods
nil.to_s
nil.to_i

# Sve osim nil i false je true
if 0
  puts "0 is true"
else
  puts "0 is false"
end

# Classes are open
# ------------------
# klasu je moguće u svakom trenutku otvoriti, promjeniti, dodati nešto, ... sve čak i core klase
class Numeric
  def plus(x)
    self + x
  end
end

puts 3.plus 2

# ? and ! methods
# -----------------
# ? - methods that respond with true | false
[].empty?
[1,2].empty?
##### ! - methods koje mjenaju sami objekt
str = " Vlado "
puts str.strip
puts str
puts str.strip!
puts str

# Missing methods
# ---------------
class SillyData
  attr_reader :data
  
  def initialize(data)
    @data = data
  end
  
  def method_missing(id, *arguments)
    case id
    when :find_by_name
      data.select { |hash| hash[:name] == arguments.first }.first
    when :find_by_surname
      data.select { |hash| hash[:surname] == arguments.first }.first
    else
      raise NoMethodError
    end
  end
  
  # [:name, :surname].each do |item|
  #   define_method "find_by_#{item}" do |value|
  #     data.select { |hash| hash[item] == value }.first
  #   end
  # end
end

sd = SillyData.new([{ :name => "Vlado", :surname => "Cingel" }, { :name => "Josip", :surname => "Balen" }])
puts sd.data
puts sd.find_by_name("Vlado")
puts sd.find_by_surname("Balen")
puts sd.respond_to?(:find_by_name)
# sd.find_by_nickname("nesto")

# Cesto se koristi za detaljnije izvještaje o errorima
# Railsi je koriste za to, find_by_...
# Mogući izvor bugova
# ne odogovara na respond_to
# define_method puno bolja opcija - odogovara na respond_to, jednostavno

# Single inheritance
# ------------------
class Animal
end

class Dog < Animal
end

# Modules
# -------
# Other option is delegation
module Sleeper
  def sleep_all_day
    puts "ZZZZZZ ZZZ ZZ Z"
  end
  def wake_up_early
    puts "I can't do that"
  end
end

class Dog < Animal
  include Sleeper
end

garo = Dog.new
garo.sleep_all_day
garo.wake_up_early

# Threading, GLI
# Other implemntations
# Jruby - 
# Rubinius - compiles