class StringHelper
  class << self
  def warnstrip!(string)
    warn 'Beginning or end of string has spaces! In: ' + string unless string == string.strip
    string.strip!
  end
  end
end