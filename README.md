# stripe-event-mock

This gem extracts the webhook fixtures from the [stripe-ruby-mock](https://github.com/stripe-ruby-mock/stripe-ruby-mock) gem.

It simplifies the approach and removed all the mocking for Stripe objects. SO use RSpec mocks or VCR for this.

The purpose is to be able to step-by-step remove `stripe-ruby-mock` from the codebase, but still be able to make use of the fixture files for webhook events.

Removing `stripe-ruby-mock` is nessecary as it is no longer maintained and not compatible with current versions of the official `stripe` gem.