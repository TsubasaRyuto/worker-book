def fill_autocomplete(field, options = {})
  page.find(".#{field}").send_keys((options[:with]).to_s)
  sleep 1
  page.execute_script %{ $('ul.ui-autocomplete li.ui-menu-item div.ui-menu-item-wrapper:contains("#{options[:select]}")').trigger('mouseenter').click() }
end
