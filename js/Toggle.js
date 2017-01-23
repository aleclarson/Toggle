var Children, ReactType, Style, TapResponder, View, ref, type;

ref = require("react-validators"), Style = ref.Style, Children = ref.Children;

TapResponder = require("TapResponder");

ReactType = require("modx/lib/Type");

View = require("modx/lib/View");

type = ReactType("Toggle");

type.defineOptions({
  value: Number.withDefault(0),
  maxValue: Number.withDefault(1),
  modes: Array.or(Object),
  tap: TapResponder
});

type.defineValues(function(options) {
  return {
    _tap: options.tap,
    _value: options.value,
    maxValue: options.maxValue,
    modes: options.modes
  };
});

type.initInstance(function() {
  var modes;
  if (!(modes = this.modes)) {
    return;
  }
  if (!Array.isArray(modes)) {
    this.modes = modes = Object.keys(modes).map(function(key) {
      var mode;
      mode = modes[key];
      mode.key = key;
      return mode;
    });
  }
  this.maxValue = modes.length - 1;
});

type.definePrototype({
  value: {
    get: function() {
      return this._value;
    },
    set: function(newValue) {
      if (newValue === this._value) {
        return;
      }
      this._value = newValue;
      this._onToggle();
    }
  },
  mode: {
    get: function() {
      return this.modes[this._value];
    }
  }
});

type.defineMethods({
  toggle: function() {
    var value;
    value = this._value;
    if (value === this.maxValue) {
      value = 0;
    } else {
      value += 1;
    }
    this._value = value;
    this._onToggle();
    return value;
  },
  _onToggle: function() {
    var onToggle;
    if (onToggle = this.props.onToggle) {
      if (this.modes) {
        onToggle(this.mode, this._value);
      } else {
        onToggle(this._value);
      }
    }
  }
});

type.defineProps({
  style: Style,
  children: Children,
  onToggle: Function
});

type.render(function() {
  var touchHandlers;
  if (this._tap) {
    touchHandlers = this._tap.touchHandlers;
  }
  return View({
    style: this.props.style,
    children: this.props.children,
    mixins: [touchHandlers]
  });
});

module.exports = type.build();

//# sourceMappingURL=map/Toggle.map
