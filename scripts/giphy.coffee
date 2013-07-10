# Description:
#   A way to search images on giphy.com
#
# Commands:
#   hubot gif me <query> - Returns an animated gif matching the requested search term.

giphy =
  api_key: process.env.HUBOT_GIPHY_API_KEY
  base_url: 'http://api.giphy.com/v1'

module.exports = (robot) ->
  robot.respond /(gif|giphy)( me)? (.*)/i, (msg) ->
    console.log msg
    giphyMe msg, msg.match[3], (url) ->
      msg.send url

giphyMe = (msg, query, cb) ->
  endpoint = '/gifs/search'
  url = "#{giphy.base_url}#{endpoint}"
  msg.http(url)
    .query
      q: query
      api_key: giphy.api_key
    .get() (err, res, body) ->
      response = undefined
      try
        response = JSON.parse(body)
        console.log '-----RESPONSE-----'
        console.log response
      catch e
        response = undefined
        this.emit('error', e)

      if response is undefined
        return
      else
        console.log '-----ELSE-----'
        console.log response
        images = response.data.gifs
        if images.length > 0
          image = msg.random images
          cb image.original_url
