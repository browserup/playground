require 'gruf'

Gruf.configure do |c|
  # The size of the underlying thread pool. No more concurrent requests can be made
  # than the size of the thread pool.
  c.server_binding_url = '0.0.0.0:9090'
  c.rpc_server_options = c.rpc_server_options.merge(pool_size: 100)
  c.backtrace_on_error = !Rails.env.production?
  c.use_exception_message = !Rails.env.production?
  c.interceptors.use(Gruf::Interceptors::Instrumentation::RequestLogging::Interceptor, formatter: :logstash)
end

relative_path_to_generated = 'lib/proto'
path_to_generated = Rails.root.join(relative_path_to_generated)

$LOAD_PATH.unshift(path_to_generated) unless $LOAD_PATH.include?(path_to_generated)
Dir.glob("#{path_to_generated}/**/*_services_pb.rb").each do |path|
  load path
end


STDOUT.sync = true
Rails.logger.level = Logger::DEBUG
