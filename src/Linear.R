#Model Creation
modnn <- nn_module(
  initialize = function(input_size, layers, type, hidUnits, dropout) {
    self$output <- nn_linear(input_size, 1)
    

  },
  forward = function(x) {
    x %>% self$output()
  }
)



