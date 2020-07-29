fetch = require 'node-fetch'
jszip = require 'jszip'
fs = require 'fs'

token = process.argv[2]
artsUrl = 'https://api.github.com/repos/LXY1226/MiraiOK/actions/artifacts'

ghApi = (url) -> await (await fetch url,
  headers:
    'authorization': "Bearer #{token}"
).json()

downArt = (url) ->
  res = await fetch url,
    headers:
      'authorization': "Bearer #{token}"
  await jszip.loadAsync res.buffer()

do ->
#module.exports = ->
  arts = await ghApi artsUrl
  files = (await downArt arts['artifacts'][0]['archive_download_url']).files
  for fileName of files
    if fileName.startsWith '.'
      continue
    file = files[fileName]
    stream = fs.createWriteStream "./miraiok/#{fileName}"
    stream.on 'error', (e) -> console.log e
    file.nodeStream().pipe stream
