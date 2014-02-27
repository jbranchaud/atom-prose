{View} = require 'atom'

module.exports =
class ProseView extends View
  @content: ->
    @div class: 'prose tool-panel panel-bottom prose-bar', =>
      @div outlet: 'stats', "say something", class: 'prose-stats'

  initialize: ->
    atom.workspaceView.proseBar = this
    atom.workspaceView.command "prose:toggle", => @toggle()

    @bufferSubscriptions = []
    @subscribe atom.workspaceView, 'pane-container:active-pane-item-changed', =>
      console.log 'hello'
      @unsubscribeAllFromBuffer()
      @storeActiveBuffer()
      @subscribeAllToBuffer()
      @setStats()

      @trigger('active-buffer-changed')

    @storeActiveBuffer()
    @setStats()

  # Private:
  attach: ->
    atom.workspaceView.appendToBottom(this) unless @hasParent()

  # Public:
  setStats: ->
    console.log 'here we are'
    #if atom.workspaceView.is '.prose'
    if @getActiveBuffer()?
      console.log 'and again'
      wordCount = @getActiveBuffer().getText().match(/\S+/g).length
      charCount = @getActiveBuffer().getText().length
      lineCount = @getActiveBuffer().getText().match(/[\n\r]/g).length
      statsString = "Words: #{wordCount}, Characters: #{charCount}, Lines: #{lineCount}"
      console.log statsString
      this.find('.prose-stats').text(statsString)

  # Public:
  getActiveBuffer: ->
    @buffer

  # Public:
  getActiveItem: ->
    atom.workspaceView.getActivePaneItem()

  # Private:
  storeActiveBuffer: ->
    @buffer = @getActiveItem()?.getBuffer?()

  # Public:
  subscribeToBuffer: (event, callback) ->
    @bufferSubscriptions.push([event, callback])
    @buffer.on(event, callback) if @buffer

  # Private:
  subscribeAllToBuffer: ->
    return unless @buffer
    for [event, callback] in @bufferSubscriptions
      @buffer.on(event, callback)

  # Private:
  unsubscribeAllFromBuffer: ->
    return unless @buffer
    for [event, callback] in @bufferSubscriptions
      @buffer.off(event, callback)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "ProseView was toggled!"
    if @hasParent()
      @detach()
    else
      @attach()
