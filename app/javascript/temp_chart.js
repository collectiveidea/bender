(function() {
  var TempChart,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  TempChart = (function() {
    function TempChart(container) {
      this.renderGraph = __bind(this.renderGraph, this);
      this.updateGraph = __bind(this.updateGraph, this);
      this.prepData = __bind(this.prepData, this);
      this.loadData = __bind(this.loadData, this);
      this.draw = __bind(this.draw, this);
      this.deactivateNext = __bind(this.deactivateNext, this);
      this.activateNext = __bind(this.activateNext, this);
      this.container = container;
      this.graphContainer = this.container.find(".graph-wrapper");
      this.url = this.container.data('sensor-url');
      this.sensor = this.container.data('sensor-id');
      this.duration = this.container.data('duration') || 21600;
      if ((this.container.data('graph-end') != null) && this.container.data('graph-end') !== "") {
        this.graphEnd = parseFloat(this.container.data('graph-end'));
      } else {
        this.graphEnd = (new Date()).valueOf() / 1e3;
      }
      this.graphStart = this.graphEnd - this.duration;
      this.frozen = false;
      if (typeof fayeClient !== "undefined" && fayeClient !== null) {
        fayeClient.subscribe("/temperature/" + this.sensor, (function(_this) {
          return function(message) {
            var data;
            if (!_this.frozen) {
              message = $.parseJSON(message);
              _this.data.push(message);
              _this.graphEnd = message[1];
              _this.graphStart = _this.graphEnd - _this.duration;
              data = _this.data.filter(obj => obj[1] >= _this.graphStart);
              return _this.prepData(data, 200);
            }
          };
        })(this));
      }
      this.container.find(".next").on("click", (function(_this) {
        return function(e) {
          var el;
          e.preventDefault();
          el = $(e.currentTarget);
          el.blur();
          if (!el.hasClass("inactive")) {
            _this.graphEnd = _this.graphEnd + _this.duration;
            _this.now = (new Date()).valueOf() / 1e3;
            if (_this.now < _this.graphEnd) {
              _this.graphEnd = _this.now;
              _this.deactivateNext();
            }
            _this.graphStart = _this.graphEnd - _this.duration;
            return _this.draw();
          }
        };
      })(this));
      this.container.find(".prev").on("click", (function(_this) {
        return function(e) {
          e.preventDefault();
          $(e.currentTarget).blur();
          _this.graphEnd = _this.graphStart;
          _this.graphStart = _this.graphEnd - _this.duration;
          _this.activateNext();
          return _this.draw();
        };
      })(this));
      this.container.find(".current").on("click", (function(_this) {
        return function(e) {
          var el;
          e.preventDefault();
          el = $(e.currentTarget);
          el.blur();
          if (!el.hasClass("inactive")) {
            _this.graphEnd = (new Date()).valueOf() / 1e3;
            _this.graphStart = _this.graphEnd - _this.duration;
            _this.deactivateNext();
            return _this.draw();
          }
        };
      })(this));
    }

    TempChart.prototype.activateNext = function() {
      this.container.find(".current").removeClass("inactive");
      this.container.find(".next").removeClass("inactive");
      return this.frozen = true;
    };

    TempChart.prototype.deactivateNext = function() {
      this.container.find(".current").addClass("inactive");
      this.container.find(".next").addClass("inactive");
      return this.frozen = false;
    };

    TempChart.prototype.draw = function() {
      this.container.find('.loading').show();
      return this.loadData();
    };

    TempChart.prototype.loadData = function() {
      return $.ajax({
        url: "/temperature_sensors/" + this.sensor + "/" + this.duration + "/" + (Math.round(this.graphStart)) + ".json",
        dataType: 'json',
        success: this.prepData
      });
    };

    TempChart.prototype.prepData = function(data, status) {
      this.data = data;
      this.data.forEach(function(d) {
        d.x = d[1] + (new Date(d[1] * 1e3)).getTimezoneOffset() * 60;
        return d.y = parseFloat(d[0]);
      });
      if (this.rickshaw != null) {
        return this.updateGraph();
      } else {
        return this.renderGraph();
      }
    };

    TempChart.prototype.updateGraph = function() {
      this.rickshaw.end = this.graphEnd + (new Date(this.graphEnd * 1e3)).getTimezoneOffset() * 60;
      this.rickshaw.start = this.graphStart + (new Date(this.graphStart * 1e3)).getTimezoneOffset() * 60;
      this.rickshaw.series[0].data = this.data;
      this.rickshaw.update();
      this.container.find('.loading').hide();
      if (this.data.length > 1) {
        return this.container.find('.no-data').hide();
      } else {
        return this.container.find('.no-data').show();
      }
    };

    TempChart.prototype.renderGraph = function() {
      if (this.data.length > 1) {
        this.rickshaw = new Rickshaw.Graph({
          element: this.graphContainer[0],
          width: this.graphContainer.width(),
          height: this.graphContainer.height(),
          renderer: "line",
          start: this.graphStart + (new Date(this.graphStart * 1e3)).getTimezoneOffset() * 60,
          end: this.graphEnd + (new Date(this.graphEnd * 1e3)).getTimezoneOffset() * 60,
          min: "auto",
          interpolation: "linear",
          series: [
            {
              color: 'steelblue',
              data: this.data,
              name: "F"
            }
          ],
          padding: {
            top: .01,
            bottom: .1,
            left: .03,
            right: .01
          }
        });
        this.hoverDetail = new Rickshaw.Graph.HoverDetail({
          graph: this.rickshaw,
          yFormatter: function(e) {
            return e;
          },
          xFormatter: function(e) {
            return (new Date(e * 1e3)).toUTCString();
          },
          formatter: function(e, t, n, r, i, s) {
            return i + "&nbsp;" + e.name;
          }
        });
        this.xAxis = new Rickshaw.Graph.Axis.Time({
          graph: this.rickshaw,
          ticksTreatment: "glow"
        });
        this.yAxis = new Rickshaw.Graph.Axis.Y({
          graph: this.rickshaw,
          tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
          ticksTreatment: "glow",
          pixelsPerTick: this.graphContainer.height() / 2
        });
        this.container.find('.loading').hide();
        this.container.find('.no-data').hide();
        return this.rickshaw.render();
      } else {
        this.container.find('.loading').hide();
        return this.container.find('.no-data').show();
      }
    };

    return TempChart;

  })();

  $(function() {
    return $('.temp-chart').each(function(idx) {
      return new TempChart($(this)).draw();
    });
  });

}).call(this);
