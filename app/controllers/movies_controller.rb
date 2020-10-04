class MoviesController < ApplicationController

def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || Movie.all_ratings_as_hash
    sort = params[:sort]
    
    
    if((sort == nil && session[:sort] != nil) || (@selected_ratings == nil && session[:ratings] != nil))
        if(sort == nil && session[:sort] != nil)
            sort = session[:sort]
        end
        if(@selected_ratings == nil && session[:ratings] != nil)
            @selected_ratings = session[:ratings]
        elsif
            puts "SETTING AS HASH"
            @selected_ratings = Movie.all_ratings_as_hash
        end
        redirect_to movies_path(:sort => sort, :ratings => @selected_ratings)
    end
    
    session[:sort] = sort
    session[:ratings] = @selected_ratings
      
    if sort == 'by_title'
        @title_class = 'bg-warning  hilite'
        @movies = Movie.with_ratings(session[:ratings].keys).order(:title)
        
    elsif sort == 'by_date'
        @date_class = 'bg-warning hilite'
        @movies = Movie.with_ratings(session[:ratings].keys).order(:release_date)
    else
        @movies = Movie.with_ratings(session[:ratings].keys)
    end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
