require 'google/apis/youtube_v3'

class YoutubeController < ApplicationController
  def index
    @channels = YoutubeService.new(search_params[:search]).call
  end

  private

  def search_params
    params.permit(:search)
  end
end
