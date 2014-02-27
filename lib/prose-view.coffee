{View} = require 'atom'

module.exports =
class ProseView extends View
  @content: ->
    @div class: 'prose tool-panel panel-bottom prose-bar', =>
      editorView = atom.workspaceView.getActiveView().getEditor()
      wordCount = editorView.getText().match(/\S+/g).length
      charCount = editorView.getText().length
      lineCount = editorView.getText().match(/[\n\r]/g).length
      @div "Words: #{wordCount}, Characters: #{charCount}, Lines: #{lineCount}", class: "message"

  initialize: ->
    atom.workspaceView.proseBar = this
    atom.workspaceView.command "prose:toggle", => @toggle()

    @bufferSubscriptions = []
    @subscribe atom.workspaceView, 'pane-container:active-pane-item-changed', =>
      @unsubscribeAllFromBuffer()
      @storeActiveBuffer()
      @subscribeAllToBuffer()

      @trigger('active-buffer-changed')

    @storeActiveBuffer()

  # Private:
  attach: ->
    atom.workspaceView.appendToBottom(this) unless @hasParent()

  # Public:
  appendLeft: (item) ->
    @leftPanel.append(item)

  # Public:
  appendRight: (item) ->
    @rightPanel.append(item)

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
