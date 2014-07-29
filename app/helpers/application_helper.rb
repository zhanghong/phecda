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

  def left_menu_link_item(name, option = {}, html_options = {})
    icon_name = html_options.delete(:icon)
    text = <<-TXT
      <i class="#{icon_name} fa icon-text-width"></i>
      <span class="menu-text">#{name}</span>
    TXT
    link_to(raw(text), option, html_options)
  end

  def left_menu_link_unless(condition, name, options = {}, html_options = {}, &block)
    if condition
      if block_given?
        block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
      else
        %Q(<li class="active">#{left_menu_link_item(name, options, html_options)}</li>)
      end
    else
      %Q(<li>#{left_menu_link_item(name, options, html_options)}</li>)
    end
  end
end
