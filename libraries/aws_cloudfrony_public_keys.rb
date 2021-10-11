# frozen_string_literal: true

require 'aws_backend'

class AWSCloudFrontPublicKeys < AwsResourceBase
  name 'aws_cloudfront_public_keys'
  desc 'Lists all Public Keys.'

  example "
    describe aws_cloudfront_public_keys do
      it { should exist }
    end
  "

  attr_reader :table

  FilterTable.create
             .register_column(:id, field: :id)
             .register_column(:name, field: :name)
             .register_column(:created_time, field: :created_time)
             .register_column(:encoded_key, field: :encoded_key)
             .register_column(:comment, field: :comment)
             .install_filter_methods_on_resource(self, :table)

  def initialize(opts = {})
    super(opts)
    validate_parameters
    @table = fetch_data
  end

  def fetch_data
    catch_aws_errors do
      @table = @aws.cloudfront_client.list_public_keys.map do |table|
        table.public_key_list.items.map { |table_name| {
          quantity: table_name.quantity,
          id: table_name.id,
          created_time: table_name.created_time,
          name: table_name.name,
          encoded_key: table_name.encoded_key,
          comment: table_name.comment,
        }
        }
      end.flatten
    end
  end
end
