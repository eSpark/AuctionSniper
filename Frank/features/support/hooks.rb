After do |scenario|
  if @server
    @server.disconnect!
  end
end
