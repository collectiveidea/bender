(function() {
  $(function() {
    return $('[data-typeahead]').on('keyup', function(e) {
      var $this, pattern, searchClass;
      $this = $(this);
      pattern = $this.val().toLowerCase();
      searchClass = $this.data("typeahead-search");
      return $($this.data("typeahead")).children().each(function(idx) {
        if ($(this).find("" + searchClass).text().toLowerCase().search(pattern) === -1) {
          return $(this).slideUp(200);
        } else {
          return $(this).slideDown(200);
        }
      });
    });
  });

}).call(this);
