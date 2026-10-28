# ==========================================
# 1. RESOURCE DISCOVERY DATA SOURCES
# ==========================================

# Query all EC2 instances (running and stopped) for tracking and cost monitoring
data "aws_instances" "all_ec2" {
  instance_state_names = ["pending", "running", "stopping", "stopped"]
}

# Pull deep attributes for each discovered EC2 instance
data "aws_instance" "ec2_details" {
  for_each    = toset(data.aws_instances.all_ec2.ids)
  instance_id = each.value
}

# Query all Security Groups
data "aws_security_groups" "all_sgs" {}

# Query all S3 Buckets
data "aws_s3_buckets" "all_s3" {}

# Query all EC2 Key Pairs
data "aws_key_pairs" "all_keys" {}

# Query all VPCs
data "aws_vpcs" "all_vpcs" {}


# ==========================================
# 2. COMPREHENSIVE DETAILED OUTPUTS
# ==========================================

output "infrastructure_audit_report" {
  description = "Complete detailed audit of all resources and cost-driving factors in AWS (eu-north-1)"
  value = {
    
    # SECTION A: Compute & Cost Risk Factors (EC2 + Public IPs)
    compute_resources = {
      total_instances_found = length(data.aws_instances.all_ec2.ids)
      instances = {
        for id, inst in data.aws_instance.ec2_details : id => {
          name              = lookup(inst.tags, "Name", "No Name Tag")
          instance_type     = inst.instance_type
          state             = inst.instance_state
          public_ip         = inst.public_ip != "" ? inst.public_ip : "None (No hourly public IPv4 charge)"
          availability_zone = inst.availability_zone
          cost_risk_note    = inst.instance_state == "running" ? "ACTIVE: Accumulating compute hours & public IP fees" : "STOPPED: Compute paused, but check for attached EBS volume or IPv4 holding fees"
        }
      }
    },

    # SECTION B: Network & Security Architecture
    network_security = {
      vpc_count             = length(data.aws_vpcs.all_vpcs.ids)
      vpc_ids               = data.aws_vpcs.all_vpcs.ids
      security_group_count  = length(data.aws_security_groups.all_sgs.ids)
      security_group_ids    = data.aws_security_groups.all_sgs.ids
    },

    # SECTION C: Storage & Credentials
    storage_and_access = {
      s3_bucket_count = length(data.aws_s3_buckets.all_s3.names)
      s3_buckets      = data.aws_s3_buckets.all_s3.names
      key_pairs_found = data.aws_key_pairs.all_keys.key_names
    }
  }
}
