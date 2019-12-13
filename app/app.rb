require 'sinatra'
require 'slack-ruby-client'

get '/' do
  'ok'
end

post '/' do
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

    profile_name = ""
    profile_photo_url = "https://a.slack-edge.com/80588/marketing/img/icons/icon_slack_hash_colored.png"  #dummy
    profile_emp_no = ""
    profile_group = ""
    profile_position = ""

    block = [
      type: "section",
      accessory: {
        type: "image",
        image_url: profile_photo_url,
        alt_text: "photo"
      },
      fields: [
				{
          type: "mrkdwn",
          text: "*名前*\n#{profile_name}"
        },
        {
          type: "mrkdwn",
          text: "*社員番号*\n#{profile_emp_no}"
        },
        {
          type: "mrkdwn",
          text: "*グループ*\n#{profile_group}"
        },
        {
          type: "mrkdwn",
          text: "*役職*\n#{profile_position}"
        }
      ]
    ]

    slack_client.chat_postEphemeral(
      channel: requset_slack_channel_id,
      user: request_slack_user_id,
      blocks: block
    )
    
    return # slack response
  rescue => error
    'うまく探せなかった、ごめん :bow:'
  end
end
