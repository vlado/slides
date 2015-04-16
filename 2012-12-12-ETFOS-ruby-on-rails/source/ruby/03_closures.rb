# Blocks, Lambdas, Procs
# Closures
# http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/
# ----------------------

array = [1, 2, 3]
array.map! { |n| n ** 2  }
puts array.inspect

# 1. Prvo smo poslali map! metodu našem nizu zajedno sa blokom
# 2. blok uzima varijablu iz map! metode i diže ju na kvadrat
# 3. Svaki element u nizu je sada na kvadrat

# Kako ovo u stvari radi, idemo napisati našu vlastitu map! metodu

class Array
  def iterate!
    self.each_with_index do |n,index|
      self[index] = yield(n)
    end
  end
end

array = [1, 2, 3]
array.iterate! { |n| n ** 2  }
# array.iterate!
puts array.inspect

# Koristi smo ! jer je ovo opasna metoda (in place edit)
# Blok se poziva sa ključnom riječi yield
# Bloku smo poslali parametar n
# Blok automatski vraća zadnju linuju koda (ne vraća return)

# Drugi način da pozovemo blok je da ga pozovemo kao Proc objekt (procedura)
# Proc je block koda vezan uz varijablu

class Array
  def iterate!(&code)
    self.each_with_index do |n,index|
      self[index] = code.call(n)
    end
  end
end

array = [1, 2, 3]
array.iterate! { |n| n ** 2  }
puts array.inspect

# Razlike:
# dodali smo & argument koji je dakako naš blok
# Umjesto yield šaljemo call našem bloku
# Rezultat je isti, zašto razlike u sintaksi?
# Ajmo vidjeti šta su blokovi u stvari

def what_is_block(&block)
  block.class
end

puts what_is_block {}

# Blokovi su izuzetno zgodni i jednostavne sintakse, ali šta ako imamo potrebu za više blokova i da ih pozivamo vieše puta?
# Ako se odlučimo za procedure možemo radit ovakve stvari:

class Array
  def iterate!(code)
    self.each_with_index do |n,index|
      self[index] = code.call(n)
    end
  end
end

square = Proc.new do |n|
  n ** 2
end
multiply_by_2 = Proc.new do |n|
  n * 2
end

array1 = [1, 2, 3]
array2 = [4, 5, 6]

array1.iterate!(multiply_by_2)
puts array1.inspect

array2.iterate!(multiply_by_2)
puts array2.inspect

# Ne stavljamo & ispred argumenta jer je proc objek kao is svaki drugi

# Zašto Proc velikim slovima?
# Proc je class unutar rubyja, block je sintaksa

array = [1,2,3]
array.iterate!(Proc.new do |n|
  n ** 2
end)

# Ovo je potpuno ispravno (podsječa na to kako je closure implementiran u drugim jezicima). Ne izgleda baš Ruby like, zar ne
# Zašto onda ne bi uvijek koristili blokove?
# Pogledajmo ovu situaciju. Imamo više od jednog callbacka

def callbacks(options)
  options[:before].call
  puts "do something"
  options[:after].call
end

callbacks :before => Proc.new { puts "Before" }, :after => Proc.new { puts "After" }

# Procedure su nešto slično kao anonimne funkcije u drugim jezicima ili kako ih se još naziva lambdas. Ali Ruby ima i to :)

array.iterate!(lambda { |n| n ** 2 })
puts array.inspect

# Razlika je da lambda provjerava broj varijabli a Proc ne (postavlja ih na nil)
# Druga razlika je da Proc vraća vrijednost sa returnom i prekida program a lambda vraća vrijednost i nastavlja sa programom
def proc_return
  Proc.new { return "Proc" }.call
  puts "Proc return"
end

def lambda_return
  lambda { return "Lambda" }.call
  puts "Lambda return"
end

proc_return
lambda_return

# Procs su drop in dijelovi koda
# lambda se ponaša kao metoda, broj argumenata, return, ...

def generic_return(code)
  code.call
  return "generic return"
end

# generic_return(Proc.new { return "Proc" })
generic_return(lambda { return "Lambda" })

# -> drugi naziv za lambda u 1.9

# Ali ima još

def square(n)
  n ** 2
end

# što ako bi postojeću metodu koja nam paše pa da ne pišemo ponovno htjeli ubacit i iskoristi kao blok?

array.iterate!(method(:square))
puts array.inspect

# method method (postojeći metodu koristimo kao closure, block)