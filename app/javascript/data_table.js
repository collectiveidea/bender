(function() {
  $(function() {
    return $('#leaderboard.data-table').dataTable({
      "aaSorting": [[1, 'desc']],
      "bFilter": false,
      "bInfo": false,
      "bPaginate": false
    });
  });

}).call(this);
