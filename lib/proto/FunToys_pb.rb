# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: FunToys.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("FunToys.proto", :syntax => :proto3) do
    add_message "rpc.FunToy" do
      optional :id, :uint32, 1
      optional :name, :string, 2
      optional :description, :string, 3
    end
    add_message "rpc.GetFunToyReq" do
      optional :id, :uint32, 1
    end
    add_message "rpc.GetFunToyResp" do
      optional :fun_toy, :message, 1, "rpc.FunToy"
    end
    add_message "rpc.GetFunToysReq" do
      optional :search, :string, 1
      optional :limit, :uint32, 2
    end
    add_message "rpc.CreateFunToysResp" do
      repeated :fun_toys, :message, 1, "rpc.FunToy"
    end
  end
end

module Rpc
  FunToy = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.FunToy").msgclass
  GetFunToyReq = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.GetFunToyReq").msgclass
  GetFunToyResp = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.GetFunToyResp").msgclass
  GetFunToysReq = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.GetFunToysReq").msgclass
  CreateFunToysResp = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.CreateFunToysResp").msgclass
end