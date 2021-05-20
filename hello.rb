# coding: utf-8

require "socket"
ss = TCPServer.open(8080)

loop do
	Thread.start(ss.accept) do |s|
		request = s.gets.chomp
		puts("Request: " + request)

		status = "200 OK"
		header = "Content-Type: text/html; charset=utf-8"
		body = "<html><body>こんにちは世界</body></html>"
		s.puts("HTTP/1.0 " + status + "\r\n" + header + "\r\n\r\n" + body)
			
		# ヒアドキュメントを使う方法
		#s.puts(<<~EOHTTP)
		#  HTTP/1.0 #{status}
		#  #{header}
		#
		#  #{body}
		#EOHTTP

		s.close
	end 
end


