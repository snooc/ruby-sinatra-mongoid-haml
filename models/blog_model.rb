require 'mongoid'

class Blog_model
  include Mongoid::Document
  
  field :title, :type => String
  field :body, :type => String
  field :created_at, :type => Time, :default => Time.now
  field :modified_at, :type => Time, :default => Time.now 
end