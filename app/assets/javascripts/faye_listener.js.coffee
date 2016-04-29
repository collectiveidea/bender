$ ->
  if fayeClient?
    $("div[data-sensor-id]").each ()->
      element = $(this)
      sensorId = element.data('sensor-id')
      fayeClient.subscribe "/temperature/#{sensorId}", (message) ->
        message = $.parseJSON(message)
        element.find('.temperature').html(parseFloat(message[0]).toFixed(1))
        element.find('.when').html(moment(message[1] * 1e3).format("llll"))

    if $('.activity-feed').size() > 0
      fayeClient.subscribe "/pour/create", (message) ->
        location.reload()

      fayeClient.subscribe "/pour/update", (message) ->
        message = $.parseJSON(message)
        element = $("#pour_#{message.id}")
        if element.length == 1
          element.find(".volume").html(parseFloat(message.volume).toFixed(1))
        else
          location.reload()

      fayeClient.subscribe "/pour/complete", (message) ->
        location.reload()
