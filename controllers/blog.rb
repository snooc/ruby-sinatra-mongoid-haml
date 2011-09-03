require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'mongoid'
require 'models/blog_model'

class Blogger < Sinatra::Base
  # directory path settings relative to app file
  set :root, File.join(File.dirname(__FILE__), '..')
  set :public, Proc.new { File.join(root, 'public') }
  set :method_override, true
  
  configure do
     Mongoid.configure do |config|
      name = "mongoid_dev"
      host = "localhost"
      config.master = Mongo::Connection.new.db(name)
    end
  end
  
  def initialize
    super
  end

  get '/' do
    redirect '/blogs'
  end
  
  # list all blogs
  get '/blogs' do
    @docs = Blog_model.all()
    haml :'blog/index', :locals => { :title => "My Blog Lists", :blogs => @docs }
  end
  
  #view a blog
  get '/show.:id' do |id|
    @doc = Blog_model.find(id)
    haml :'blog/show', :locals => { :title => "Blog", :blog => @doc}
  end  
  
  # write new blog
  get '/new' do
    haml :'blog/new', :locals => { :title => "New Blog"}
  end  
  
  post '/new' do
    @blog = params[:blog]
    @doc = Blog_model.new
    @doc.title = @blog[:title]
    @doc.body = @blog[:body]
    if @doc.save
      puts 'Nice Blog'
      redirect '/blogs'
    else
      puts "Error(s): ", @doc.errors.map {|k,v| "#{k}: #{v}"}
      haml :'blog/error', :locals => { :errs => @doc.errors } 
    end
  end
  
  #edit blog
  get '/edit.:id' do |id|
    @doc = Blog_model.find(id)
    haml :'blog/edit', :locals => { :title => "Edit Blog", :blog => @doc}
  end
  
  put '/edit.:id' do |id|
    @doc = Blog_model.find(id)
    @doc.update_attributes(params[:blog])
    @doc.update_attributes({:modified_at => Time.now})
    redirect '/show.'+id
  end
  
  #delete blog
  delete '/:id' do |id|
    @doc = Blog_model.find(id)
    @doc.delete
    redirect '/'
  end
end

      