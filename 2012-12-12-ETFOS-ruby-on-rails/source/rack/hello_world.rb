# Rack provides a minimal interface between webservers supporting Ruby and Ruby frameworks.
# Supported webservers and frameworks - http://rack.rubyforge.org/doc/

class HelloWorld
  def call(env)
    [200, {"Content-Type" => 'text/plain'}, ["Hello World!"]]
  end
end

# Ako maknemo header dobit cemo grešku jer je CT header obavezan. Ljepe greške su rezultat Rack::ShowExceptions i Rack::Lint
# middlewarea. Ako se dogodi greška oni ce vratiti [] ako ne prosljedit će request dalje. Ako ništa ne presretne na kraju
# odgovara naša aplikacija
class HelloWorld
  def call(env)
    [200, {}, ["Hello World!"]]
  end
end

# Naporno je stalno upisivat ove nizove sa hederima i svima. Zato postoji Rack::Response koji ima već postavljene neke defaulte
class HelloWorld
  def call(env)
    Rack::Response.new("Hello world!")
  end
end

# HTML je naporno ubacivat i generirat direktno pa je bolje koristiti neki templating engine
# http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html, jednostavn moćan i dolazi sa rubyjem
class HelloWorld
  def call(env)
    Rack::Response.new(render('index.html.erb'))
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    # Objects of class Binding encapsulate the execution context at some particular place in the code and retain this context for future use.
    # The variables, methods, value of self, and possibly an iterator block that can be accessed in this context are all retained
    ERB.new(File.read(path)).result(binding)
  end
end

# Za sada uvijek vraćamo isti odgvovor. Idemo sad vidjet kako bi vratali nešto ovisino o requestu
class HelloWorld
  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when '/' then Rack::Response.new(render('index.html.erb'))
    when '/change'
      Rack::Response.new do |response|
        response.set_cookie('name', @request.params['name'])
        response.redirect('/')
      end
    else
      Rack::Response.new('Not found!', 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    # Objects of class Binding encapsulate the execution context at some particular place in the code and retain this context for future use.
    # The variables, methods, value of self, and possibly an iterator block that can be accessed in this context are all retained
    ERB.new(File.read(path)).result(binding)
  end

  def name
    @request.cookies['name'] || 'World'
  end
end


# Rack application is a thing that responds to #call and takes a hash as argument, returning an array of status, headers and a body
# env['rack.input'], ...

# On top of this minimal API, there are libraries for commonly used things like query parsing or cookie handling and provide more
# convenience (Rack::Request and Rack::Response) that you are free to use if you wish.

# But the really cool thing about Rack is that it provides an extremely easy way to combine these web applications.
# After all, they are only Ruby objects with a single method that matters. And the thing that calls you must not really
# be a web server, but could as well be a different application!


