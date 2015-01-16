###
  Location Editor for Slickgrid
  Edits and set latitude/longitude pairs
###

@LocationEditor = (args) ->
  form = null
  loadValue = null

  form = $('<input type="text" class="editor-text" />')
  form.appendTo args.container
  form.focus()

  closeForm = =>
    args.grid.getEditorLock().commitCurrentEdit()
    args.grid.resetActiveCell()
    
  $('body').on 'click.slickgrid-location', (e) =>
    if $(e.target).closest('.slick-cell.active').length == 0
      closeForm()

  form.popover
    container: 'body'
    content: 'Please enter a valid latitude and longitude.'
    placement: 'bottom'
    trigger: 'manual'

  destroy: ->
    $('body').off 'click.slickgrid-location'
    form.popover 'destroy'
    form.remove()
  focus: ->
    form.focus()
  isValueChanged: =>
    form.val() != loadValue
  serializeValue: ->
    form.val()
  loadValue: (item) ->
    loadValue = item[args.column.field] || ''
    form.val loadValue
  applyValue: (item, state) ->
    item[args.column.field] = state
  validate: ->
    isLocation = /^((?:\+|-)?\d+\.?\d*), ((?:\+|-)?\d+\.?\d*)$/
    result = isLocation.exec form.val()

    unless result?
      form.popover 'show'
      {valid: false, msg: 'Please enter a valid latitude and longitude'}
    else if Math.abs(parseInt(result[1])) > 90
      form.popover 'show'
      {valid: false, msg: 'Please enter a latitude within -90 to 90 degrees'}
    else if Math.abs(parseInt(result[2])) > 180
      form.popover 'show'
      {valid: false, msg: 'Please enter a longitude within -180 to 180 degrees'}
    else
      form.popover 'hide'
      {valid: true, msg: null}
