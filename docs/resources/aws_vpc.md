---
title: About the aws_vpc Resource
platform: aws
---

# aws\_vpc

Use the `aws_vpc` InSpec audit resource to test properties of a single AWS Virtual Private Cloud (VPC) and the CIDR Block that is used within the VPC.

Each VPC is uniquely identified by its ID. In addition, each VPC has a non-unique CIDR IP address range (such as 10.0.0.0/16), which it manages.

Every AWS account has at least one VPC, the "default" VPC, in every region.

## Syntax

An `aws_vpc` resource block identifies a VPC by ID. If no VPC ID is provided, the default VPC is used.

    # Find the default VPC
    describe aws_vpc do
      it { should exist }
    end

    # Find a VPC by ID
    describe aws_vpc('vpc-12345678987654321') do
      it { should exist }
    end

    # Hash syntax for ID
    describe aws_vpc(vpc_id: 'vpc-12345678') do
      it { should exist }
    end

#### Parameters

If no parameter is provided, the subscription's default VPC will be returned.

##### vpc\_id _(optional)_

This resource accepts a single parameter, the VPC ID.
This can be passed either as a string or as a `vpc_id: 'value'` key-value entry in a hash.

See also the [AWS documentation on VPCs](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html).

## Properties

|Property         | Description|
| ---             | --- |
|cidr\_block       | The IPv4 address range that is managed by the VPC. |
|dhcp\_options\_id  | The ID of the set of DHCP options associated with the VPC (or `default` if the default options are associated with the VPC). |
|instance\_tenancy | The allowed tenancy of instances launched into the VPC. |
|state            | The state of the VPC (`pending` | `available`). |
|vpc\_id           | The ID of the VPC. |
|tags             | The tags of the VPC. |
|ipv\_6\_cidr\_block\_association\_set (association\_id) | The association ID for an IPv6 CIDR block associated with the VPC. |
|ipv\_6\_cidr\_block\_association\_set (ipv\_6\_cidr_block) | An IPv4 CIDR block associated with the VPC. |
|ipv\_6\_cidr\_block\_association\_set (network\_border\_group) | The name of the location from which we advertise the IPV6 CIDR block. Use this parameter to limit the CIDR block to this location. |
|ipv\_6\_cidr\_block\_association\_set (ipv\_6\_pool) | The ID of the IPv6 address pool from which the IPv6 CIDR block is allocated. |
|ipv\_6\_cidr\_block\_association\_set (ipv\_6\_cidr\_block\_state (state)) | The state of an IPv6 CIDR block associated with the VPC. |
|ipv\_6\_cidr\_block\_association\_set (ipv_6\_cidr\_block\_state (status\_message)) | The status message of an IPv6 CIDR block associated with the VPC |
|cidr\_block\_association\_set (association\_id) | The association ID for a CIDR block associated with the VPC. |
|cidr\_block\_association\_set (cidr\_block\_state (state)) | The state of a CIDR block associated with the VPC. |
|cidr\_block\_association\_set (cidr\_block\_state (status\_message)) | The status message of a CIDR block associated with the VPC. |

## Examples

The following examples show how to use this InSpec audit resource.

### Test the CIDR Block of a named VPC

    describe aws_vpc('vpc-87654321') do
      its('cidr_block') { should cmp '10.0.0.0/16' }
    end

### Test the state of the VPC

    describe aws_vpc do
      its ('state') { should eq 'available' }
      # or equivalently
      it { should be_available }
    end

### Test the allowed tenancy of instances launched into the VPC.

    describe aws_vpc do
      its ('instance_tenancy') { should eq 'default' }
    end

### Test tags on the VPC

    describe aws_vpc do
      its('tags') { should include(:Environment => 'env-name',
                                   :Name => 'vpc-name')}
    end

### Test the IPV6 CIDR Block association set state of a named VPC

    describe aws_vpc do
      its ('ipv_6_cidr_block_association_set.first.ipv_6_cidr_block_state.state')
                { should eq aws_ipv_6_cidr_block_association_set_ipv_6_cidr_block_state_state }
    end

### Test the CIDR Block association set association_id of a named VPC

    describe aws_vpc do
      its ('cidr_block_association_set.first.association_id') { should eq aws_cidr_block_association_set_association_id }
    end

## Matchers

This InSpec audit resource has the following special matchers. For a full list of available matchers, please visit our [matchers page](https://www.inspec.io/docs/reference/matchers/).

### be\_default

The test will pass if the identified VPC is the default VPC for the region.

    describe aws_vpc('vpc-87654321') do
      it { should be_default }
    end

## AWS Permissions

Your [Principal](https://docs.aws.amazon.com/IAM/latest/UserGuide/intro-structure.html#intro-structure-principal) will need the `ec2:DescribeVpcs` action with Effect set to Allow.

You can find detailed documentation at [Actions, Resources, and Condition Keys for Amazon EC2](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazonec2.html).
