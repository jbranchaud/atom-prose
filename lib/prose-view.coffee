{View} = require 'atom'

module.exports =
class ProseView extends View
  @content: ->
    @div class: 'prose overlay from-bottom word-count', =>
      editorView = atom.workspaceView.getActiveView()
      wordCount = editorView.text().match(/\S+/g).length
      charCount = editorView.text().length
      @div "Words: #{wordCount}, Characters: #{charCount}, Lines: 15", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "prose:toggle", => @toggle()

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
      atom.workspaceView.append(this)
