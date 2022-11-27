#(Boehmke & Greenwell 2020, 269)

library(tfruns)

FLAGS <- flags(
  # Nodes
  flag_numeric("nodes1", 256),
  flag_numeric("nodes2", 128),
  flag_numeric("nodes3", 64),
  # Dropout
  flag_numeric("dropout1", 0.4),
  flag_numeric("dropout2", 0.3),
  flag_numeric("dropout3", 0.2),

  # Learning parameters
  flag_string("optimizer", "rmsprop"),
  flag_numeric("lr_annealing", 0.1)
)


model <- keras_model_sequential() %>%
  layer_dense(units = FLAGS$nodes1, activation = "relu", input_shape = p) %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = FLAGS$dropout1) %>%
  layer_dense(units = FLAGS$nodes2, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = FLAGS$dropout2) %>%
  layer_dense(units = FLAGS$nodes3, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = FLAGS$dropout3) %>%
  layer_dense(units = 10, activation = "softmax") %>%
  compile(
    loss = 'categorical_crossentropy',
    metrics = c('accuracy'),
    optimizer = FLAGS$optimizer
  ) %>%
  fit(
    x = mnist_x,
    y = mnist_y,
    epochs = 35,
    batch_size = 128,
    validation_split = 0.2,
    callbacks = list(
      callback_early_stopping(patience = 5),
      callback_reduce_lr_on_plateau(factor = FLAGS$lr_annealing)
    ),
    verbose = FALSE
  )





runs <- tuning_run("src/MLForecasting.Rmd",
                    flags = list(
                      nodes1 = c(64, 128, 256),
                      nodes2 = c(64, 128, 256),
                      nodes3 = c(64, 128, 256),
                      dropout1 = c(0.2, 0.3, 0.4),
                      dropout2 = c(0.2, 0.3, 0.4),
                      dropout3 = c(0.2, 0.3, 0.4),
                      optimizer = c("rmsprop", "adam"),
                      lr_annealing = c(0.1, 0.05)
                    ),
                    sample = 0.05
)
runs %>%
  filter(metric_val_loss == min(metric_val_loss)) %>%
  glimpse()