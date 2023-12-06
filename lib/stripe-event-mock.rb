# based on the event mocking from stripe-ruby-mock
# see: https://github.com/stripe-ruby-mock/stripe-ruby-mock/blob/master/lib/stripe_mock/api/webhooks.rb

module StripeEventMock
  class UnsupportedRequestError < StandardError; end

  @webhook_fixture_path = './spec/fixtures/stripe_webhooks/'
  @webhook_fixture_fallback_path = File.join(File.dirname(__FILE__), 'stripe_event_mock/webhook_fixtures')

  def self.mock_webhook_payload(type, params = {})

    fixture_file = File.join(@webhook_fixture_path, "#{type}.json")

    unless File.exist?(fixture_file)
      unless Webhooks.event_list.include?(type)
        raise UnsupportedRequestError.new "Unsupported webhook event `#{type}` (Searched in #{@webhook_fixture_path})"
      end

      fixture_file = File.join(@webhook_fixture_fallback_path, "#{type}.json")
    end

    json = MultiJson.load File.read(fixture_file)

    json = Stripe::Util.symbolize_names(json)
    params = Stripe::Util.symbolize_names(params)
    json[:account] = params.delete(:account) if params.key?(:account)
    json[:data][:object] = rmerge(json[:data][:object], params)
    json.delete(:id)
    json[:created] = params[:created] || Time.now.to_i
    json[:id] ||= "evt_#{SecureRandom.hex(10)}"

    Stripe::Util.symbolize_names(json)
  end

  def self.mock_webhook_event(type, params={})
    Stripe::Event.construct_from(mock_webhook_payload(type, params))
  end

  def self.rmerge(desh_hash, source_hash)
    return source_hash if desh_hash.nil?
    return nil if source_hash.nil?

    desh_hash.merge(source_hash) do |key, oldval, newval|
      if oldval.is_a?(Array) && newval.is_a?(Array)
        oldval.fill(nil, oldval.length...newval.length)
        oldval.zip(newval).map {|elems|
          if elems[1].nil?
            elems[0]
          elsif elems[1].is_a?(Hash) && elems[1].is_a?(Hash)
            rmerge(elems[0], elems[1])
          else
            [elems[0], elems[1]].compact
          end
        }.flatten
      elsif oldval.is_a?(Hash) && newval.is_a?(Hash)
        rmerge(oldval, newval)
      else
        newval
      end
    end
  end

  module Webhooks
    def self.event_list
      @__list = Dir.glob(File.join(File.dirname(__FILE__), 'stripe_event_mock/webhook_fixtures/*.json')).map do |file|
        File.basename(file, '.json')
      end
    end
  end
end
