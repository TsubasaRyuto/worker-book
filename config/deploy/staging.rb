set :stage, :staging
set :rails_env, :staging
set :puma_pid, -> { File.join(shared_path, "tmp", "pids", "puma.pid") }

load_balancer_name = ENV['AWS_LOAD_BALANCER_NAME']
elasticloadbalancing = Aws::ElasticLoadBalancing::Client.new
instance_states = elasticloadbalancing.describe_instance_health(load_balancer_name: load_balancer_name).instance_states
target_ids = instance_states.map(&:instance_id)

ec2 = Aws::EC2::Client.new
response = ec2.describe_instances(instance_ids: target_ids)
dns_names = response.reservations.map { |r| r.instances.map(&:public_dns_name) }.flatten

dns_names.each do |dns|
  server dns, user: 'centos', roles: %w{app web db batch}
end

set :ssh_options, {
  keys: %w(~/.ssh/workerbook-staging.pem),
  forward_agent: true,
  auth_methods: %w(publickey)
}
