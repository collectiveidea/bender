(function() {
  $(function() {
    if (typeof fayeClient !== "undefined" && fayeClient !== null) {
      $("div[data-sensor-id]").each(function() {
        var element, sensorId;
        element = $(this);
        sensorId = element.data('sensor-id');
        return fayeClient.subscribe("/temperature/" + sensorId, function(message) {
          element.find('.temperature').html(parseFloat(message[0]).toFixed(1));
          return element.find('.when').html(moment(message[1] * 1e3).format("llll"));
        });
      });
      if ($('.activity-feed').size() > 0) {
        fayeClient.subscribe("/pour/create", function(message) {
          return location.reload();
        });
        fayeClient.subscribe("/pour/update", function(message) {
          var element;
          element = $("#pour_" + message.id);
          if (element.length === 1) {
            return element.find(".volume").html(parseFloat(message.volume).toFixed(1));
          } else {
            return location.reload();
          }
        });
        return fayeClient.subscribe("/pour/complete", function(message) {
          return location.reload();
        });
      }
    }
  });

}).call(this);
