# coding: utf-8

require "socket"
require "cgi/util"
require "pathname"

LOG = Pathname(__dir__) / "bbs.log"

ss = TCPServer.open(8080)

loop do
  Thread.start(ss.accept) do |s|
    path, params = s.gets.split[1].split("?")
    header = ""
    body = ""
    name = "名無し"
	
	if params != nil
      params.split("&").each do |param|
        pair = param.split("=")
        pname = pair[0]
        pvalue = CGI.unescape(pair[1]==nil ? "" : pair[1])
        name = pvalue.encode("utf-8") if pname == "name"
      end
	end

    if path == "/"
      status = "200 OK"
      header = "Content-Type: text/html; charset=utf-8"
      body = "<html><body>こんにちは#{name}さん</body></html>"
	  
	  
    log = []
	if name != "名無し"
		log.unshift("訪問者: #{name} (#{Time.new})\n")
		
		File.open(LOG, "a") do |f|
			f.print log.join("\n")
		end
	end
	  
    else
      status = "302 Moved"
      header = "Location: /"
    end

    s.write(<<~EOHTTP)
      HTTP/1.0 #{status}
      #{header}

      #{body}
    EOHTTP

    puts "#{Time.new} #{status} #{path}"

    s.close
  end
end
