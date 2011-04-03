// Place your application-specific JavaScript functions and classes here
$(document).ready(function() {
  
  twttr.anywhere(function (T) {
    // T("#users_a img, #users_b img").hovercards({ username: function(node){ return node.title; } });
    T("#users_a, #users_b").hovercards();
  });
  
});

// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) console.log( Array.prototype.slice.call(arguments) );
};

