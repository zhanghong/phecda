module ApplicationHelper
  def format_time(time)
    if time.is_a?(Time)
      time.strftime("%Y-%m-%d %H:%M:%S")
    else
      ""
    end
  end

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

  def l_or_humanize(s, options={})
    k = "#{options[:prefix]}#{s}".to_sym
    ::I18n.t(k, :default => s.to_s.humanize)
  end 
end
