class GeneralsController < ApplicationController

  def index
    render "generals/index", layout: "layout"
  end

  def contact
    render "generals/contact", layout: "layout"
  end

  def about
    render "generals/about", layout: "layout"
  end

end
