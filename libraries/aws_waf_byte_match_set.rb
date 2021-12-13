# frozen_string_literal: true

require 'aws_backend'

class AWSWAFByteMatchSet < AwsResourceBase
  name 'aws_waf_byte_match_set'
  desc 'Describes one WAF byte set.'

  example "
    describe aws_waf_byte_match_set(byte_match_set_id: 'BYTE_MATCH_SET_ID') do
      it { should exits }
    end
  "

  def initialize(opts = {})
    opts = { byte_match_set_id: opts } if opts.is_a?(String)
    super(opts)
    validate_parameters(required: %i(byte_match_set_id))
    raise ArgumentError, "#{@__resource_name__}: byte_match_set_id must be provided" unless opts[:byte_match_set_id] && !opts[:byte_match_set_id].empty?
    @display_name = opts[:byte_match_set_id]
    catch_aws_errors do
      resp = @aws.waf_client.get_byte_match_set({ byte_match_set_id: opts[:byte_match_set_id] })
      @resp = resp.byte_match_set.to_h
      create_resource_methods(@resp)
    end
  end

  def byte_match_set_id
    return nil unless exists?
    @resp[:byte_match_set_id]
  end

  def exists?
    !@resp.nil? && !@resp.empty?
  end

  def to_s
    "Resource ID: #{@display_name}"
  end
end
