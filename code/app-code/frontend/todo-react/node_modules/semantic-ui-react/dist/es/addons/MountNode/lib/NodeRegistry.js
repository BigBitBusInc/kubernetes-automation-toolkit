var NodeRegistry = function NodeRegistry() {
  var _this = this;

  this.add = function (nodeRef, component) {
    if (_this.nodes.has(nodeRef)) {
      var set = _this.nodes.get(nodeRef);

      set.add(component);
      return;
    }

    _this.nodes.set(nodeRef, new Set([component]));
  };

  this.del = function (nodeRef, component) {
    if (!_this.nodes.has(nodeRef)) return;

    var set = _this.nodes.get(nodeRef);

    if (set.size === 1) {
      _this.nodes.delete(nodeRef);

      return;
    }

    set.delete(component);
  };

  this.emit = function (nodeRef, callback) {
    callback(nodeRef, _this.nodes.get(nodeRef));
  };

  this.nodes = new Map();
};

export { NodeRegistry as default };