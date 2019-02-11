class FiguresController < ApplicationController
  enable :sessions
  
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/figures' do
    @figures = Figure.all
    erb :"figures/index"
  end

  get '/figures/new' do
    @titles = Title.all
    erb :"figures/new"
  end

  post '/figures' do
    @figure = Figure.create(:name => params[:figure][:name])

    @titles = Title.all
    @figure.title_ids = params[:figure][:titles]
    if !params[:figure][:title_name].empty?
    	@figure.titles << Title.create(:name => params[:figure][:title_name])
    end

    @landmarks = Landmark.all
    @figure.landmark_ids = params[:figure][:landmarks]
    if !params[:figure][:landmark_name].empty?
    	@figure.landmarks << Landmark.create(:name => params[:figure][:landmark_name], :year => params[:figure][:landmark_year])
    end

    @figure.save
    redirect to "figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    id = params[:id]
    @figure = Figure.find_by_id(id)
    erb :"figures/edit"
  end

  patch '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])
    @figure.name = params[:figure][:name]
    
    @figure.title_ids = params[:figure][:titles]
    if @figure.titles
      @figure.titles.clear
    end
    titles = params[:figure][:titles]
    titles.each do |title|
      @figure.titles << Title.find(title)
    end

    if !params[:figure][:title_name].empty?
    	@figure.titles << Title.create(:name => params[:figure][:title_name])
    end

    @figure.landmark_ids = params[:figure][:landmarks]
    if @figure.landmarks
      @figure.landmarks.clear
    end

    landmarks = params[:figure][:landmarks]
    landmarks.each do |landmark|
      @figure.landmarks << Landmark.find(landmark)
    end

    if !params[:figure][:landmark_name].empty?
    	@figure.landmarks << Landmark.create(:name => params[:figure][:landmark_name], :year_completed => params[:figure][:landmark_year])
    end

    @figure.save
    
    redirect to "/figures/#{@figure.id}"
  end
 
end
