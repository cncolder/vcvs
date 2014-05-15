# JSON.stringify for RegExp
RegExp.prototype.toJSON = -> @source
