// From http://stackoverflow.com/questions/7624920/number-sign-in-javascript
sign = function (x) {
  return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
};


