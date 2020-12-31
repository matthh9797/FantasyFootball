cost_model2 <- function(x, y) {
  sum(abs(x - y)) / length(x)
}