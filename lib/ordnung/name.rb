module Ordnung
  class Name
    @@names = Hash.new
    def Name.create name
      id = @@names[name]
      return id if id
      @@names[name] = @@names.size
    end
  end
end
