# coding: utf-8

require "socket"

ss = TCPServer.open(8080)

loop do
  Thread.start(ss.accept) do |s|
    path = s.gets.split[1]
    header = ""
    body = ""

    case path
    when "/hello.html"
      status = "200 OK"
      header = "Content-Type: text/html; charset=utf-8"
      body = "<html><body>こんにちは世界</body></html>"
    when "/hello2.html"
      status = "200 OK"
      header = "Content-Type: text/html; charset=utf-8"
      body = "<html><body>こんにちは世界2</body></html>"
    else
      status = "302 Moved"
      header = "Location: /hello.html"
    end

    s.puts(<<~EOHTTP)
      HTTP/1.0 #{status}
      #{header}

      #{body}
    EOHTTP

    puts "#{Time.new} #{status} #{path}"

    s.close
  end
end
