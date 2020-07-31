fetch = require 'node-fetch'
  .default
jszip = require 'jszip'
fs = require 'fs'

token = process.argv[2]
miraiOKArtsUrl = 'https://api.github.com/repos/LXY1226/MiraiOK/actions/artifacts'
miraiApiHttpUrl = 'https://api.github.com/repos/project-mirai/mirai-api-http/actions/artifacts'

ghApi = (url) -> await (await fetch url,
  headers:
    'authorization': "Bearer #{token}"
).json()

downArt = (url) ->
  res = await fetch url,
    headers:
      'authorization': "Bearer #{token}"
  await jszip.loadAsync res.buffer()

down = (url, folder) ->
  arts = await ghApi url
  files = (await downArt arts['artifacts'][0]['archive_download_url']).files
  for fileName of files
    if fileName.startsWith '.'
      continue
    file = files[fileName]
    stream = fs.createWriteStream "#{folder}#{fileName}"
    stream.on 'error', (e) -> console.log e
    file.nodeStream().pipe stream

do ->
  await down miraiOKArtsUrl, './miraiok/'
  await down miraiApiHttpUrl, './mirai-api-http/'
