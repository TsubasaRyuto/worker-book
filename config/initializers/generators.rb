Rails.application.config.generators do |g|
  g.helper false
  g.test_framework :rspec,
    fixtures: false,
    view_specs: false,
    helper_specs: false,
    routing_spec: false
  g.fixture_replacement :factory_girl, dir: "spec/factories"
end
