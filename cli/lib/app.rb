class App
  attr_accessor :creds, :potato

  def whoami
    @creds.name
  end
end

class NotLoggedInException < StandardError
end

class Creds
  attr_accessor :path

  def name
    found_name = creds["name"]
    raise NotLoggedInException.new unless found_name
    found_name
  end

  def creds
    creds_path = path || "~/.cpci.conf"
    JSON.parse(File.read(creds_path))
  end
end
