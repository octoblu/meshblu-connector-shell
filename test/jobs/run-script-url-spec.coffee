{job} = require '../../jobs/run-script-url'

describe 'RunScriptUrl', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        runScriptUrl: sinon.stub().yields null
      message =
        data:
          url: 'foo'
          workingDirectory: 'home'
          env: [name: "DEBUG", value: '*']
          args: [1,2,3]
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.runScriptUrl', ->
      options =
        url: 'foo'
        workingDirectory: 'home'
        env: [name: "DEBUG", value: '*']
        args: [1,2,3]
      expect(@connector.runScriptUrl).to.have.been.calledWith options

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
