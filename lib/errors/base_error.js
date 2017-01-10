// Generated by CoffeeScript 1.9.3
(function() {
  var BaseError, RecoverableError, UnrecoverableError,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  BaseError = (function(superClass) {
    extend(BaseError, superClass);

    function BaseError() {
      return BaseError.__super__.constructor.apply(this, arguments);
    }

    BaseError.prototype.toString = function() {
      return this.message.message;
    };

    return BaseError;

  })(Error);

  RecoverableError = (function(superClass) {
    extend(RecoverableError, superClass);

    function RecoverableError(message, cause) {
      this.message = message;
      this.cause = cause;
      this.retryable = true;
      RecoverableError.__super__.constructor.apply(this, arguments);
    }

    return RecoverableError;

  })(BaseError);

  UnrecoverableError = (function(superClass) {
    extend(UnrecoverableError, superClass);

    function UnrecoverableError(message, cause) {
      this.message = message;
      this.cause = cause;
      this.retryable = false;
      UnrecoverableError.__super__.constructor.apply(this, arguments);
    }

    return UnrecoverableError;

  })(BaseError);

  module.exports = {
    BaseError: BaseError,
    RecoverableError: RecoverableError,
    UnrecoverableError: UnrecoverableError
  };

}).call(this);