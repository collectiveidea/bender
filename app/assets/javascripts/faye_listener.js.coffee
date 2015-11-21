$ ->
  if fayeClient?
    $("div[data-sensor-id]").each ()->
      element = $(this)
      sensorId = element.data('sensor-id')
      fayeClient.subscribe "/temperature/#{sensorId}", (message) ->
        message = $.parseJSON(message)
        element.find('span').html(parseFloat(message[0]).toFixed(1))

    if $('.activity-feed').size() > 0
      fayeClient.subscribe "/pour/complete", (message) ->
        location.reload()

      fayeClient.subscribe "/pour/update", (message) ->
        location.reload()
