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

    redirect_link = false
    
    if params[:ratings].nil? && !session[:ratings].nil? && @checked_values.nil?
      @checked_values = session[:ratings]
      redirect_link = true
    else
      session.delete(:ratings)
      session[:ratings] = params[:ratings]
      @checked_values = session[:ratings]
      redirect_link = false   
    end
    
    if params[:sort].nil? && !session[:sort].nil? && @sorted_values.nil?
      @sorted_values = session[:sort]
      redirect_link = true
    else
      session.delete(:sort)
      session[:sort] = params[:sort]
      @sorted_values = session[:sort]
      redirect_link = false      
    end
    
    if redirect_link
      redirect_to movies_path({:ratings => @checked_values, :sort => @sorted_values})
    end 
      
    @all_ratings = Movie.ratings
    
    # If Parameters exit, store them in the session.
    if !params[:ratings].nil?
      session.delete(:ratings)
      session[:ratings] = params[:ratings]
      checkbox = params[:ratings]
      @checked_values = params[:ratings]
    end
   
    if !params[:sort].nil?
      sorting = params[:sort]
      session.delete(:sort)
      session[:sort] = sorting
      @sorted_values = session[:sort]
    elsif !session[:sort].nil?
      sorting = session[:sort]
    end
    
    if sorting == 'title'
      sort_order = :title
      
    elsif sorting == 'release_date'
      sort_order = :release_date
    else
      sort_order = ''
    end
    
    if checkbox.respond_to?(:keys)
        @movies = Movie.where("rating in (:all_ratings)", {all_ratings: checkbox.keys}).order(sort_order)
    else
      @movies = Movie.all.order(sort_order)
      @checked_values = @all_ratings
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

end
