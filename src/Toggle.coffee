
{Style, Children} = require "react-validators"

TapResponder = require "TapResponder"
ReactType = require "modx/lib/Type"
View = require "modx/lib/View"

type = ReactType "Toggle"

type.defineOptions
  value: Number.withDefault 0
  maxValue: Number.withDefault 1
  modes: Array.or Object
  tap: TapResponder

type.defineValues (options) ->

  _tap: options.tap

  _value: options.value

  maxValue: options.maxValue

  modes: options.modes

type.initInstance ->

  return if not modes = @modes

  if not Array.isArray modes
    @modes = modes = Object.keys(modes).map (key) ->
      mode = modes[key]
      mode.key = key
      return mode

  @maxValue = modes.length - 1
  return

type.definePrototype

  value:
    get: -> @_value
    set: (newValue) ->
      return if newValue is @_value
      @_value = newValue
      @_onToggle()
      return

  mode:
    get: -> @modes[@_value]

type.defineMethods

  toggle: ->

    value = @_value
    if value is @maxValue
    then value = 0
    else value += 1

    @_value = value
    @_onToggle()
    return value

  _onToggle: ->
    if onToggle = @props.onToggle
      if @modes
      then onToggle @mode, @_value
      else onToggle @_value
    return

#
# Rendering
#

type.defineProps
  style: Style
  children: Children
  onToggle: Function

type.render ->
  {touchHandlers} = @_tap if @_tap
  return View
    style: @props.style
    children: @props.children
    mixins: [touchHandlers]

module.exports = type.build()
