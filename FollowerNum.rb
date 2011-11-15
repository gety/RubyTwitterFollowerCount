# Count the number of followers and people who each user follows

require 'rubygems'
require 'twitter'
require 'pp'

YOUR_CONSUMER_KEY       = 'ÇŸÇ∞ÇŸÇ∞'
YOUR_CONSUMER_SECRET    = 'Ç”Å[Ç”Å['
YOUR_OAUTH_TOKEN        = 'Ç€Ç…Ç“Ç…'
YOUR_OAUTH_TOKEN_SECRET = 'Ç‡Ç∞Ç‡Ç∞'

Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

# Initialize your Twitter client

followers = Twitter.follower_ids("hanamaru_gety")
friends = Twitter.friend_ids("hanamaru_gety")

follower_idlist = followers["ids"]
friend_idlist = friends["ids"]
intersection_idlist = follower_idlist & friend_idlist
union_idlist = follower_idlist | friend_idlist

pp union_idlist
pp intersection_idlist

guilty = union_idlist - intersection_idlist
puts "#{guilty.length} : People you follow who do not follow you"

printf("%-20s %10s %10s\n", "screen_name", "friends", "followers")
puts "-" * 50
guilty.each do |user_id|
	user = Twitter.user(user_id)
	printf("%-20s %-10s %-10s\n", user.screen_name, user.friends_count, user.followers_count)
end

