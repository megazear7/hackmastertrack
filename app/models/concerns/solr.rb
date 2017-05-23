module Solr extend ActiveSupport::Concern
  def solrSanitize str
=begin
    str.gsub!("-", "\-")
    str.gsub!("+", "\+")
    str.gsub!("&&", "\&&")
    str.gsub!("||", "\||")
    str.gsub!("!", "\!")
    str.gsub!("(", "\(")
    str.gsub!(")", "\)")
    str.gsub!("{", "\{")
    str.gsub!("}", "\}")
    str.gsub!("[", "\[")
    str.gsub!("]", "\]")
    str.gsub!("^", "\^")
    str.gsub!("\"", "\\\"")
    str.gsub!("~", "\~")
    str.gsub!("*", "\*")
    str.gsub!("?", "\?")
    str.gsub!(":", "\:")
    str.gsub!("\\", "\\\\")
=end

    #return URI.escape(str)
    return str
  end
end
