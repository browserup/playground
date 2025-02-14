
Regenerating the REST API:

modify spec/requests/toys_spec.rb

rm public/api-docs/v1/swagger.yaml; RAILS_ENV=test rails rswag

-----------------------------------------
GRPC:

brew install grpcurl

grpcurl -plaintext -import-path lib/proto -proto lib/proto/FunToys.proto -d '{"id": 1}' 0.0.0.0:9090 rpc.FunToys/GetFunToy

bundle exec rake test:get_fun_toy

Demo:  https://github.com/bigcommerce/gruf-demo/tree/main/lib/proto
Gruf:  https://github.com/bigcommerce/gruf

Regenerating the GRPC API Doc at public/index.html:
docker run --rm --platform=linux/amd64 -v $(pwd)/public/doc:/out -v $(pwd)/lib/proto:/protos pseudomuto/protoc-gen-doc

----------------------------------------
Credits:

# Rails chat application
Code of the rails chat tutorial from [iridakos.com](https://iridakos.com/tutorials/2019/04/04/creating-chat-application-rails-websockets.html)

![Bash completion demo](https://iridakos.com/assets/images/posts/rails-chat-tutorial/rails-chat-tutorial.gif)

# MIT License

Copyright (c) 2019 Lazarus Lazaridis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
