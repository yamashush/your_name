require 'sinatra'
require 'slack-ruby-client'

get '/' do
  'ok'
end

post('/') do
  begin
    # slack slash commands payload
    # @see https://api.slack.com/slash-commands
    req = URI.decode_www_form(request.body.read)
    request_slack_user_id = req.assoc('user_id').last
    requset_slack_channel_id = req.assoc('channel_id').last
    profile_slack_user_name = req.assoc('text').last

    slack_client = Slack::Web::Client.new(
      token: ENV['SLACK_BOT_TOKEN']
    )
    res = slack_client.users_info(user: profile_slack_user_name)
    profile_slack_user_email = res['user']['profile']['email'] 

  rescue => error
    'うまく探せなかった、ごめん :bow:'
  end
end
