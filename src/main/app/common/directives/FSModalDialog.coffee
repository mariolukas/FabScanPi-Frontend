name = 'fabscan.directives.FSModalDialog'
angular.module(name,[]).directive("modalDialog", [
  '$log'
  ($log)->

  restrict: 'E'
  scope: show: '='
  replace: true
  transclude: true
  link: (scope, element, attrs) ->
    scope.dialogStyle = {}
    if attrs.width
      scope.dialogStyle.width = attrs.width
    if attrs.height
      scope.dialogStyle.height = attrs.height

    scope.hideModal = ->
      scope.show = false
      return

    return
  template: "<div class='ng-modal' ng-show='show'>
    <div class='ng-modal-overlay' ng-click='hideModal()'></div>
    <div class='ng-modal-dialog' ng-style='dialogStyle'>
      <div class='ng-modal-close' ng-click='hideModal()'>X</div>
      <div class='ng-modal-dialog-content' ng-transclude></div>
    </div>
  </div>"
])