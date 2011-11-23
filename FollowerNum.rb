# -*- coding: cp932 -*-
# Count the number of followers and people who each user follows
# 	-f	oauth-info-file
# 	-u	twitter-user-name

require 'rubygems'
require 'twitter'
require 'pp'
require 'optparse'

# Here, you can describe access info directly
YOUR_CONSUMER_KEY       = 'ほげほげ'
YOUR_CONSUMER_SECRET    = 'ふーふー'
YOUR_OAUTH_TOKEN        = 'ぽにぴに'
YOUR_OAUTH_TOKEN_SECRET = 'もげもげ'
YOUR_USER_NAME			= 'てろてろ'

# Check command line options
OPTS = {}
opt = OptionParser.new
begin 
  opt.on('-f VAL') {|v| OPTS[:f] = v}
  opt.on('-u VAL') {|v| OPTS[:u] = v}
  opt.parse!(ARGV)
rescue
  puts "#{__FILE__}: unrecognized option \`#{ARGV[0]} \'"
  exit
end
# Check OAuth file name option
# -- File Format --------------
# Consumer Key
# Consumer Secret
# Access Token
# Access Token Secret
# -----------------------------
if OPTS[:f]
  # Read OAuth information file name
  f = open(OPTS[:f], "r")
  ck = f.gets.chomp
  cs = f.gets.chomp
  ot = f.gets.chomp
  ots = f.gets.chomp
else
  # If no arguments
  ck = YOUR_CONSUMER_KEY
  cs = YOUR_CONSUMER_SECRET
  ot = YOUR_OAUTH_TOKEN
  ots = YOUR_OAUTH_TOKEN_SECRET
end
# Check user name option
if OPTS[:u]
  # Set twitter user name
  uname = OPTS[:u]
else
  uname = YOUR_USER_NAME
end


Twitter.configure do |config|
  config.consumer_key = ck
  config.consumer_secret = cs
  config.oauth_token = ot
  config.oauth_token_secret = ots
end

# Initialize your Twitter client
followers = Twitter.follower_ids(uname)
friends = Twitter.friend_ids(uname)

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

