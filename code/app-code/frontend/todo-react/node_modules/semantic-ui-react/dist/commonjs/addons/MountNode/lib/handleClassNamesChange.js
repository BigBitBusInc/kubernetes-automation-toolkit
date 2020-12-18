"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

exports.__esModule = true;
exports.default = void 0;

var _forEach2 = _interopRequireDefault(require("lodash/forEach"));

var _computeClassNames = _interopRequireDefault(require("./computeClassNames"));

var _computeClassNamesDifference = _interopRequireDefault(require("./computeClassNamesDifference"));

var prevClassNames = new Map();
/**
 * @param {React.RefObject} nodeRef
 * @param {Object[]} components
 */

var handleClassNamesChange = function handleClassNamesChange(nodeRef, components) {
  var currentClassNames = (0, _computeClassNames.default)(components);

  var _computeClassNamesDif = (0, _computeClassNamesDifference.default)(prevClassNames.get(nodeRef), currentClassNames),
      forAdd = _computeClassNamesDif[0],
      forRemoval = _computeClassNamesDif[1];

  if (nodeRef.current) {
    (0, _forEach2.default)(forAdd, function (className) {
      return nodeRef.current.classList.add(className);
    });
    (0, _forEach2.default)(forRemoval, function (className) {
      return nodeRef.current.classList.remove(className);
    });
  }

  prevClassNames.set(nodeRef, currentClassNames);
};

var _default = handleClassNamesChange;
exports.default = _default;