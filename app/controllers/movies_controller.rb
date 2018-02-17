class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.ratings

    #Set ratings to all ratings or saved ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    #Default sort by id
    session[:sort] ||= 'id'

    #Highlight selected title or ratings header
    if params[:sort] == 'title'
      @title_hilite = session[:title_hilite] = "hilite"
    if params[:sort] == 'release_date'
      @date_hilite = session[:date_hilite] = "hilite"

    #Save settings for part 3
    session[:ratings] = params[:ratings].keys if params[:ratings]
    session[:sort] = params[:sort] if params[:sort]

    #Preserving restful by passing hash to movies_path and saving with session
    redirect_to movies_path(ratings: Hash[session[:ratings].map {|r| [r,1]}], sort: session[:sort]) if  params[:ratings].nil? || params[:sort].nil?

    #save rating and sort values
    @ratings = session[:ratings]
    @sort = session[:sort]
  
    #Set movies to new list depending on rating settings AND sort
    @movies = Movie.where(rating: @ratings).order(@sort)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end