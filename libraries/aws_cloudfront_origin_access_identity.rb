# frozen_string_literal: true

require 'aws_backend'

class AWSCloudFrontOriginAccessIdentity < AwsResourceBase
  name 'aws_cloudfront_origin_access_identity'
  desc 'Get the information about an origin access identity.'

  example "
    describe aws_cloudfront_origin_access_identity(id: 'ID') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    opts = { id: opts } if opts.is_a?(String)
    super(opts)
    validate_parameters(required: %i(id))
    raise ArgumentError, "#{@__resource_name__}: id must be provided" unless opts[:id] && !opts[:id].empty?
    @display_name = opts[:id]
    catch_aws_errors do
      resp = @aws.cloudfront_client.get_cloud_front_origin_access_identity({ id: opts[:id] })
      @res = resp.cloud_front_origin_access_identity.to_h
      create_resource_methods(@res)
    end
  end

  def resource_id
    @res? @res[:id]: @display_name
  end

  def id
    return nil unless exists?
    @res[:id]
  end

  def exists?
    !@res.nil? && !@res.empty?
  end

  def to_s
    "ID: #{@display_name}"
  end
end
