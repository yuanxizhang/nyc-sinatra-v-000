class LandmarksController < ApplicationController
  enable :sessions
  
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/landmarks' do
    @landmarks = Landmark.all
    erb :"landmarks/index"
  end

  get '/landmarks/new' do
    erb :"landmarks/new"
  end

  post '/landmarks' do
    @landmark = Landmark.create(:name => params[:landmark][:name], :year => params[:landmark][:year_completed])
    @landmark.figure = Figure.find_or_create_by(:name => params[:landmark][:figure])
    @landmark.save

    redirect to "landmarks/#{@landmark.id}"
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find_by_id(params[:id])
    erb :'landmarks/show'
  end

  patch '/landmarks/:id' do
    @landmark = Landmark.find_by_id(params[:id])
    @landmark.name = params[:landmark][:name]
    @landmark.year_completed = params[:landmark][:year_completed]
    @landmark.figure = Figure.find_or_create_by(name: params[:landmark][:figure])
    @landmark.save
    
    redirect to "/landmarks/#{@landmark.id}"
  end

  get '/landmarks/:id/edit' do
    id = params[:id]
    @landmark = Landmark.find_by_id(id)
    erb :"landmarks/edit"
  end
end
