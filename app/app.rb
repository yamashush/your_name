require 'sinatra'

get '/' do
  'ok'
end

post('/') do
  begin
    # slack slash commands payload
    # @see https://api.slack.com/slash-commands
    req = URI.decode_www_form(request.body.read)
    slack_user_id_request = req.assoc('user_id').last
    slack_channel_id_request = req.assoc('channel_id').last
    slack_user_name_profile = req.assoc('text').last

  rescue => error
    'うまく探せなかった、ごめん :bow:'
  end
end
