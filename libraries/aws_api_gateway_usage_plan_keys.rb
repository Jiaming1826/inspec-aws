# frozen_string_literal: true

require 'aws_backend'

class AWSApiGatewayUsagePlanKeys < AwsCollectionResourceBase
  name 'aws_api_gateway_usage_plan_keys'
  desc 'Lists information about a collection of Resource resources.'

  example "
    describe aws_api_gateway_usage_plan_keys(usage_plan_id: 'USAGE_PLAN_ID') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    super(opts)
    validate_parameters(required: %i(usage_plan_id))
    raise ArgumentError, "#{@__resource_name__}: usage_plan_id must be provided" if opts[:usage_plan_id].blank?
    @table = fetch(client: :apigateway_client, operation: :get_usage_plan_keys, kwargs: { usage_plan_id: opts[:usage_plan_id] }).items.map(&:to_h)
    populate_filter_table_from_response
  end
end
