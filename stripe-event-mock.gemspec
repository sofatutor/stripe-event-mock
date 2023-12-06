require_relative 'lib/stripe_event_mock/version'

Gem::Specification.new do |spec|
  spec.name          = 'stripe-event-mock'
  spec.version       = StripeEventMock::VERSION
  spec.authors     = ['sofatutor GmbH']
  spec.email       = ['support@sofatutor.com']
  spec.homepage    = 'https://sofatutor.com'
  spec.summary     = 'Be able to mock Stripe webhook events (based on stripe-ruby-mock)'

  # This domain does not exist, but setting 'allowed_push_host' avoids pushing gems accidentially to rubygems
  spec.metadata['allowed_push_host'] = 'https://gems.sofatutor.com'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{lib}/**/*', 'README.md']
  end

  spec.add_dependency 'multi_json'
  spec.add_dependency 'stripe'
end
