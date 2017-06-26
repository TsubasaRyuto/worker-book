set :stage, :production
set :rails_env, :production
set :puma_pid, -> { File.join(shared_path, 'tmp', 'pids', 'puma.pid') }
set :asset_sync_enabled, true

load_balancer_name = ENV['AWS_LOAD_BALANCER_NAME']
elasticloadbalancing = Aws::ElasticLoadBalancing::Client.new
instance_states = elasticloadbalancing.describe_instance_health(load_balancer_name: load_balancer_name).instance_states
target_ids = instance_states.map(&:instance_id)

ec2 = Aws::EC2::Client.new
response = ec2.describe_instances(instance_ids: target_ids)
ip_addresses = response.reservations.map { |r| r.instances.map(&:public_ip_address) }.flatten

ip_addresses.each do |ip|
  server ip.to_s, user: 'centos', roles: %w{app web db}
end

set :ssh_options, keys: %w(~/.ssh/workerbook-production.pem),
                  forward_agent: true,
                  auth_methods: %w(publickey)
