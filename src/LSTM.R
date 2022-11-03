# #Model Creation
# hiddenLayer = nn_module(
#   initialize = function(input_size) {
#     self$hidden <- nn_linear(input_size, hidUnits)
#     self$hidden2 <- nn_linear(hidUnits, hidUnits)
#     self$relu <- nn_relu()
#     self$sigmoid <- nn_sigmoid()
#     self$dropout <- nn_dropout(dropout)
#   },
#   forward = function(x) {
#     x %<>%
#       self$hidden() %>%
#       self$relu() %>%
#       self$dropout()
#     
#     if (layers > 1) {
#       for (n in 1:layers) {
#         x %<>%
#           self$hidden2() %>%
#           self$relu() %>%
#           self$dropout()
#       }
#     }
#     x
#   }
# )


#torch_manual_seed(13)
#inputSize = ncol(trainXPools[[1]])
modnn <- nn_module(
  initialize = function(input_size, layers, type) {
    self$output <- nn_linear(hidUnits, 1)
    self$type <- type
    self$layers <- layers
    
    self$rnn <- if (self$type == "gru") {
      nn_gru(
        input_size = input_size,
        hidden_size = hidUnits,
        num_layers = layers,
        #dropout = dropout,
        #batch_first = TRUE
      )
    } else {
      nn_lstm(
        input_size = input_size,
        hidden_size = hidUnits,
        num_layers = layers,
        #dropout = dropout,
        #batch_first = TRUE
      )
    }
    
  },
  forward = function(x) {
    # list of [output, hidden]
    # we use the output, which is of size (batch_size, n_timesteps, hidden_size)
    x <- self$rnn(x)[[1]]
    
    # from the output, we only want the final timestep
    # shape now is (batch_size, hidden_size)
    x <- x[ , dim(x)[2], ]
    
    # feed this to a single output neuron
    # final shape then is (batch_size, 1)
    x %>% self$output()
  }
)
