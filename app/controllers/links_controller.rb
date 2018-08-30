class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    puts @link.url
    ProcessVideoJob.perform_later @link.url
    redirect_to :action => 'new'
  end

  private
  
    def link_params
      params.require(:link).permit(:url)
    end
end
