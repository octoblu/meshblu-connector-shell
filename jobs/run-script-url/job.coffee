_    = require 'lodash'
http = require 'http'

class RunScriptUrl
  constructor: ({@connector}) ->
    throw new Error 'RunScriptUrl requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.url is required') unless data?.url?

    {url, args, env, workingDirectory} = data

    @connector.runScriptUrl {url, args, env, workingDirectory}, (error, data) =>
      return callback error if error?
      metadata =
        code: 200
        status: http.STATUS_CODES[200]
      return callback null, {metadata, data}

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = RunScriptUrl
