class WelcomeController < ApplicationController
  #auth callback POST comes from Steam so we can't attach CSRF token
  skip_before_filter :verify_authenticity_token, :only => :auth_callback

  def index
    @matchlist = []
    if session.key? :current_user
      url = URI.parse("http://api.steampowered.com/IDOTA2Match_570/GetLiveLeagueGames/v1/?key=#{ENV['STEAM_WEB_API_KEY']}")
      # url = URI.parse("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v001/?key=#{ENV['STEAM_WEB_API_KEY']}&account_id=#{session[:current_user]['uid']}")
      res = Net::HTTP::get(url)
      @matchlist = JSON.load(res)['result']['games'] || []

      @playerlist = []
      @accounts_list = []
      @divine = false
      @apiresult = true

      @matchlist.each do |match|
        @accounts_list += match['players']
        if match['scoreboard'] != nil
          @playerlist += match['scoreboard']['radiant']['players'] || []
          @playerlist += match['scoreboard']['dire']['players'] || []
        end
       end

      @divinelist = []

      @playerlist.each do |player|
        playerItems = []
        playerItems.push(player['item0'])
        playerItems.push(player['item1'])
        playerItems.push(player['item2'])
        playerItems.push(player['item3'])
        playerItems.push(player['item4'])
        playerItems.push(player['item5'])

        if playerItems.include? 133
          @divine = true
          playeraccount = @accounts_list.find {|a| a['account_id'].eql? player['account_id']}
          playername = playeraccount['name']
          if playeraccount['hero_id'] != 0
            playerhero = Hero.find(playeraccount['hero_id'])
            playerhero = playerhero.name
          else
            playerhero = nil
          end
          @divinelist.push({name: playername, hero: playerhero})
        end
        
      end

    end
  end

  def auth_callback
    auth = request.env['omniauth.auth']
    session[:current_user] = {:nickname => auth.info['nickname'],
                              :image => auth.info['image'],
                              :uid => auth.uid }
    redirect_to root_url
  end
end
