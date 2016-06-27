{job} = require '../../jobs/run-script'

describe 'RunScript', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        runScript: sinon.stub().yields null
      message =
        data:
          script: 'foo'
          workingDirectory: 'home'
          env: [name: "DEBUG", value: '*']
          args: [1,2,3]
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.runScript', ->
      options =
        script: 'foo'
        workingDirectory: 'home'
        env: [name: "DEBUG", value: '*']
        args: [1,2,3]
      expect(@connector.runScript).to.have.been.calledWith options

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
