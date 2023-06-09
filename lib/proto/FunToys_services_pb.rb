# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: FunToys.proto for package 'rpc'

require 'grpc'
require 'FunToys_pb'

module Rpc
  module FunToys
    class Service

      include ::GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'rpc.FunToys'

      # Demonstrates a request response call
      rpc :GetFunToy, ::Rpc::GetFunToyReq, ::Rpc::GetFunToyResp
      # Demonstrates a server streamer call
      rpc :GetFunToys, ::Rpc::GetFunToysReq, stream(::Rpc::FunToy)
      # Demonstrates a client streaming call
      rpc :CreateFunToys, stream(::Rpc::FunToy), ::Rpc::CreateFunToysResp
      # Demonstrates a bidirectional streaming call
      rpc :CreateFunToysInStream, stream(::Rpc::FunToy), stream(::Rpc::FunToy)
    end

    Stub = Service.rpc_stub_class
  end
end
