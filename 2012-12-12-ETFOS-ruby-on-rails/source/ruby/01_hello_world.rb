#!/usr/bin/env ruby

puts "Hello World!"
# puts je komanda koja ispisuje nešto. Uvijek vraća nil (Ništa)

def hello
  puts "Hello World!"
end
# method (metoda ili funkcija?)
# def hello - govori da definiramo metodu
# puts ... - je sadržaj metode
# end - govori da smo završili sa definiranjem metode

hello
hello()
# Pozivanje metode spomenom imena
# Zagrade nisu obavezne

def hello(name)
  puts "Hello #{name}!"
end
hello('Vlado')
# #{name} Ruby way za ubacit nešto u String
# hello() će sad izbaciti error

def hello(name = 'World')
  puts "Hello #{name}!"
end
hello
hello 'Vlado'
# default param - ako ime nije definirano, koristi World

class Greeter
  def initialize(name = "World")
    @name = name
  end

  def say_hi
    puts "Hi, #{@name}!"
  end

  def say_bye
    puts "Bye #{@name}, hope to see you soon"
  end
end
# ključna riješ class definira novu klasu Greeter
# @name je instance varijabla

g = Greeter.new('Vlado')
g.say_hi
g.say_bye

g = Greeter.new('Josip')
g.say_hi
g.say_bye
# initialize se poziva kod kreiranja novog objekta
# @name se definira ali mu ne možemo pristupiti direktno
# g.@name ne radi

Greeter.instance_methods
# Ispisuje sve instance metode (i classe koju Greeter nasljeđuje)

Greeter.instance_methods(false)
# Ispisuje sve instance metode (bez nasljeđa)

g.respond_to?(:name)
g.respond_to?(:say_hi)
g.respond_to?(:say_bye)
g.respond_to?(:to_s)

puts g.to_s
# to_s se poziva kad god radimo interpolaciju u string

class Greeter
  def name
    @name
  end

  def name=(name)
    @name = name
  end

  def to_s
    "Greeter #{@name}"
  end
end

puts g.name
g.name = "Josip"
puts g.name
puts g.to_s
# Možemo pregaziti (definirat vlastitu) to_s metodu nasljeđenu od Object-a
# Možemo definirat name i name= metode da mjenjamo ime

class Greeter
  attr_accessor :name
  # attr_writer :attr_names
  # attr_reader :attr_names
end
# Ruby kratica



class MegaGreeter
  attr_accessor :names

  def initialize(names = "World")
    @names = names
  end

  def say_hi
    if names.nil?
      puts "..."
    elsif names.respond_to?(:each)
      names.each do |name|
        puts "Hi #{name}!"
      end
    else
      puts "Hi #{names}!"
    end
  end

  def say_bye
    if names.nil?
      puts "..."
    elsif names.respond_to?(:join)
      puts "Bye #{names.join(', ')}!"
    else
      puts "Bye #{names}!"
    end
  end
end
# Želimo postići ovo dole pa onda polako pišemo klasu
# Mogli smo i kind_of?(Array) is_a?(Array) ali respond_to? je bolje jer nas ne zanima šta je nego šta može
# each je metoda koja prima block i izvršava taj block za svaki element u nizu.
# za svaki element u names nizu name varijabli je dodjeljen taj element i onda se blok izvršava za njega
# block is like anonymous function, lambda, clousure, ...
# (yield Ana, yield Vlado, yield Ilija, ...)
# for (i=0; i<number_of_elements; i++)
# {
#   do_something_with(element[i]);
# }
# ako netko smisli neku drugu klasu, može poslat instancu, bitno je samo da sadrži join i each metode

mg = MegaGreeter.new
mg.say_hi
mg.say_bye

mg.names = "Vlado"
mg.say_hi
mg.say_bye

mg.names = ["Ana", "Ilija", "Petar"]
mg.say_hi
mg.say_bye

mg.names = nil
mg.say_hi
mg.say_bye


