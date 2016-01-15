name = 'common.filters.toLabelFilter'

# Note that for filters I keep the name SHORT
# and they do not match the name of the module
angular.module(name, []).filter('toLabel', [
  '$log'
  ($log) ->
    (str) ->
      label_parts = str.split("-")
      date = label_parts[0]
      time = label_parts[1]

      date = date.slice(0, 4) + "-" + date.slice(4);
      date = date.slice(0, 7) + "-" + date.slice(7);

      time = time.slice(0, 2) + ":" + time.slice(2);
      time = time.slice(0, 5) + ":" + time.slice(5);

      return date+" "+time
])