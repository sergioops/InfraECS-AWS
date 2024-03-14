resource "aws_elasticache_cluster" "memcached" {
  count   = length(var.memcached_cluster)
  cluster_id           = "memcached-${var.memcached_cluster[count.index]}"
  engine               = "memcached"
  node_type            = lookup(var.memcached_instance, var.memcached_cluster[count.index])
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
}

