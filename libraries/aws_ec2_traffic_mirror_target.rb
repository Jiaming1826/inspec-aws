# frozen_string_literal: true

require 'aws_backend'

class AWSEc2TrafficMirrorTarget < AwsResourceBase
  name 'aws_ec2_traffic_mirror_target'
  desc 'Audits EC2 Traffic Mirror target'

  example "
    describe aws_ec2_traffic_mirror_target(traffic_mirror_target_id: 'test-traffic_mirror_target_id') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    opts = { traffic_mirror_target_id: opts } if opts.is_a?(String)
    super(opts)
    validate_parameters(required: %i(traffic_mirror_target_id))
    if opts[:traffic_mirror_target_id] && !opts[:traffic_mirror_target_id].empty? # Use instance_id, if provided
      if !opts[:traffic_mirror_target_id].is_a?(String) || opts[:traffic_mirror_target_id] !~ /(^tmt-[0-9a-f]{8})|(^i-[0-9a-f]{17})$/
        raise ArgumentError, "#{@__resource_name__}: `traffic_mirror_target_id` must be a string in the format of 'tmt-' followed by 8 or 17 hexadecimal characters."
      end
      @display_name = opts[:traffic_mirror_target_id]
      traffic_mirror_target_arguments = { traffic_mirror_target_ids: [opts[:traffic_mirror_target_id]] }
    end
    catch_aws_errors do
      resp = @aws.compute_client.describe_traffic_mirror_targets(traffic_mirror_target_arguments)
      @traffic_mirror_target = resp.traffic_mirror_targets[0].to_h
      create_resource_methods(@traffic_mirror_target)
    end
  end

  def exists?
    !@traffic_mirror_target.nil? && !@traffic_mirror_target.empty?
  end

  def to_s
    "EC2 Traffic Mirror target : #{@display_name}"
  end
end
