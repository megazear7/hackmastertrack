module Solr extend ActiveSupport::Concern
  def solrSanitize str
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

    return URI.escape(str)
  end
end
