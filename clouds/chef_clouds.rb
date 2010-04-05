POOL_NAME     = 'chef'
require File.dirname(__FILE__)+'/../settings'
POOL_SETTINGS = Settings[:pools][POOL_NAME.to_sym]
require File.dirname(__FILE__)+'/cloud_aspects'

# Example usage (starts the chef server, then logs in to it)
#   cloud-start -n server -c cloud/chef_clouds.rb
#   cloud-ssh   -n server -c cloud/chef_clouds.rb
# If you're on the west coast, to avoid 'ami not found' errors, first run
#   export EC2_URL=https://us-west-1.ec2.amazonaws.com

# to modify deleteOnTermination:
#   ec2-modify-instance-attribute -v i-0704be6c --block-device-mapping /dev/sda1=vol-e98d2c80::true

pool POOL_NAME do
  cloud :server do
    using :ec2
    settings = settings_for_node(POOL_NAME, :server)
    instances           1..1
    is_generic_node     settings
    is_ebs_backed       settings
    is_chef_server      settings
    is_chef_client      settings
    is_nfs_server       settings
    elastic_ip          settings[:elastic_ip]
    user                'ubuntu'
    disable_api_termination true
    puts settings.to_json
  end
end
