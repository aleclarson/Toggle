
{Type, Style, Children} = require "modx"
{View} = require "modx/views"

Tappable = require "Tappable"

type = Type "Toggle"

type.defineOptions
  value: Number.withDefault 0
  maxValue: Number.withDefault 1
  modes: Array.or Object

type.defineValues (options) ->

  value: options.value

  maxValue: options.maxValue

  modes: options.modes

  _tap: Tappable()

type.initInstance ->

  return if not modes = @modes

  if not Array.isArray modes
    @modes = modes = Object.keys(modes).map (key) ->
      mode = modes[key]
      mode.key = key
      return mode

  @maxValue = modes.length - 1
  return

type.defineBoundMethods

  _onToggle: ->

    if @value is @maxValue
    then @value = 0
    else @value += 1

    if @modes
    then @props.onToggle @mode
    else @props.onToggle @value

type.defineListeners ->

  @_tap.didTap @_onToggle

  if fn = @props.onResponderGrant
    @_tap.didGrant fn

  if fn = @props.onResponderEnd
    @_tap.didEnd fn

type.defineGetters

  mode: -> @modes[@value]

#
# Rendering
#

type.defineProps
  style: Style
  children: Children
  onToggle: Function.isRequired
  onResponderGrant: Function
  onResponderEnd: Function

type.render ->
  return View
    style: @props.style
    children: @props.children
    mixins: [@_tap.touchHandlers]

module.exports = type.build()