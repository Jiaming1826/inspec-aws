aws_vpn_connection_id = attribute(:aws_vpn_connection_id, value: '')
aws_vpn_connection_route_destination_cidr_block = attribute(:aws_vpn_connection_route_destination_cidr_block, value: '')
aws_vpn_connection_route_state = attribute(:aws_vpn_connection_route_state, value: '')

control 'aws-ec2-vpn-connection-routes-1.0' do
  impact 1.0
  title 'Lists a static route for a VPN connection between an existing virtual private gateway and a VPN customer gateway.'

  describe aws_ec2_vpn_connection_routes(vpn_connection_id: aws_vpn_connection_id) do
    it { should exist }
  end

  describe aws_ec2_vpn_connection_routes(vpn_connection_id: aws_vpn_connection_id) do
    its ('destination_cidr_blocks') { should include aws_vpn_connection_route_destination_cidr_block }
    its ('sources') { should_not be_empty }
    its ('states') { should include aws_vpn_connection_route_state }
  end

  describe aws_ec2_vpn_connection_routes(vpn_connection_id: 'vpn-1234567890') do
    it { should_not exist }
  end
end