class Device < ActiveRecord::Base
  attr_accessible :host, :id_control, :instance_key, :nome, :token, :webhook
end
