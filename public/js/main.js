var main = function() {
    function cb(start, end) {
        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }
    cb(moment().subtract(29, 'days'), moment());

    $('#reportrange').daterangepicker({
        ranges: {
           'Today': [moment(), moment()],
           'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
           'Last 7 Days': [moment().subtract(6, 'days'), moment()],
           'Last 30 Days': [moment().subtract(29, 'days'), moment()],
           'This Month': [moment().startOf('month'), moment().endOf('month')],
           'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        }
    }, cb);

    $(window).load(function(){
      $.ajax( {
        url:'/resualt/',
        data: $('span').html(),
        success:function(result) {
          $("#result").html(result);
        }
      });
    });

    $('#reportrange').on('apply.daterangepicker', function(){
      $.ajax( {
        url:'/resualt/',
        data: $('span').html(),
        success:function(result) {
          $("#result").html(result);
        }
      });
    });

};

$(document).ready(main);
