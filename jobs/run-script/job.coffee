_    = require 'lodash'
http = require 'http'

class RunScript
  constructor: ({@connector}) ->
    throw new Error 'RunScript requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.script is required') unless data?.script?

    {script, args, env, workingDirectory} = data

    @connector.runScript {script, args, env, workingDirectory}, (error, data) =>
      return callback error if error?
      metadata =
        code: 200
        status: http.STATUS_CODES[200]
      return callback null, {metadata, data}

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = RunScript
