require 'gruf'

Gruf.configure do |c|
  # The size of the underlying thread pool. No more concurrent requests can be made
  # than the size of the thread pool.
  c.server_binding_url = '127.0.0.1:409090'
  c.rpc_server_options = c.rpc_server_options.merge(pool_size: 100)
end
