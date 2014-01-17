class StaticController < ApplicationController
  def home
    render :layout => false
  end

  def about
  end

  def privacy
  end

  def terms
  end
end
