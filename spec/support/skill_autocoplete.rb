def fill_autocomplete(field, options = {})
  page.find(".#{field}").send_keys "#{options[:with]}"
  sleep 1
  page.execute_script %Q{ $('ul.ui-autocomplete li.ui-menu-item div.ui-menu-item-wrapper:contains("#{options[:select]}")').trigger('mouseenter').click() }
end
