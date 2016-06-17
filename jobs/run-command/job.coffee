_    = require 'lodash'
http = require 'http'

class RunCommand
  constructor: ({@connector}) ->
    throw new Error 'RunCommand requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.args is required') unless _.isArray data?.args

    {args} = data
    @connector.runCommand {args}, callback

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = RunCommand
