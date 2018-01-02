###
Example of how to wrap a 3rd party library, allowing it to be injectable instead of using the global var
###
name = 'common.services.FSToasterService'

angular.module(name, []).factory(name, () ->
  service = {}

  service.toastr = window.toastr
  service.toastr.newestOnTop = true
  service.toastr.options.positionClass = "toast-top-right"

  service.show = (message, level) ->

    switch level

      when "info" then service.toastr.info(message,  { timeOut: 5000 })
      when "warn" then service.toastr.warning(message)
      when "error" then service.toastr.error(message, { timeOut: 0 })
      when "success" then service.toastr.success(message)
      else service.toastr.info(message)

  # override some default settings
  # window.toastr.options.timeOut = 1000
  #window.toastr.options.
  #window.toastr.options
  #window.toastr.options.positionClass = "toast-top-left"
  return service
)