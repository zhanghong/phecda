module ApplicationHelper
  def format_date(date)
    if date.is_a?(Date) || date.is_a?(Time)
      date.strftime("%Y-%m-%d")
    else
      ""
    end
  end

  def format_price(price, precision = 2)
    number_to_currency(price, unit: "", precision: precision)
  end

  def l_or_humanize(s)
    ::I18n.t(s.to_sym, :default => s.to_s.humanize)
  end 
end
