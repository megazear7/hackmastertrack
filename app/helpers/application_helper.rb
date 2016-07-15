module ApplicationHelper
  def plus_or_minus val
    if val < 0
      return "- " + val.abs.to_s
    else
      return "+ " + val.to_s
    end
  end
end
