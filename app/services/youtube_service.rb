class YoutubeService
  def initialize(search_query)
    @search_query = search_query
    @youtube = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube.key = ENV['YOUTUBE_API_KEY']
  end

  def call
    search_response = @youtube.list_searches('id,snippet', q: @search_query, type: 'video,channel', max_results: 20)

    channels = search_response.items.each_with_object([]) do |search_result, channels|
      channels << search_result.snippet.channel_id if ['youtube#channel', 'youtube#video'].include?(search_result.id.kind)
    end

    channels.uniq.map do |channel|
      @youtube.list_channels('snippet,statistics', id: channel).items.first
    end
  end
end
