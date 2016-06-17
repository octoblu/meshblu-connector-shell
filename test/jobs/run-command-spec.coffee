{job} = require '../../jobs/run-command'

describe 'RunCommand', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        runCommand: sinon.stub().yields null
      message =
        data:
          args: []
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.runCommand', ->
      expect(@connector.runCommand).to.have.been.calledWith args: []

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
