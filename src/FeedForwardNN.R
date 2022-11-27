#Model Creation
hiddenLayer = nn_module(
  initialize = function(input_size, layers, hidUnits, dropout, actvFunc) {
    self$hidden <- nn_linear(input_size, hidUnits)
    self$hidden2 <- nn_linear(hidUnits, hidUnits)
    self$dropout <- nn_dropout(dropout)
    self$layers <- layers
    
    if (actvFunc == "relu") {
      self$actv <- nn_relu()
    } else
      self$actv <- nn_sigmoid()
    
  },
  forward = function(x) {
    x %<>%
      self$hidden() %>%
      self$actv() %>%
      self$dropout()
    
    if (self$layers > 1) {
      for (n in 1:self$layers) {
        x %<>%
          self$hidden2() %>%
          self$actv() %>%
          self$dropout()
      }
    }
    x
  }
)


modnn <- nn_module(
  initialize = function(input_size, layers, type, hidUnits, dropout, actvFunc) {
    self$hidden <- hiddenLayer(input_size, layers, hidUnits, dropout, actvFunc)
    self$output <- nn_linear(hidUnits, 1)
    
    # self$rnn <- if (self$type == "gru") {
    #   nn_gru(
    #     input_size = input_size,
    #     hidden_size = hidden_size,
    #     num_layers = num_layers,
    #     dropout = dropout,
    #     batch_first = TRUE
    #   )
    # } else {
    #   nn_lstm(
    #     input_size = input_size,
    #     hidden_size = hidden_size,
    #     num_layers = num_layers,
    #     dropout = dropout,
    #     batch_first = TRUE
    #   )
    # }
    
  },
  forward = function(x) {
    x %>%
      self$hidden() %>%
      self$output()
  }
)

