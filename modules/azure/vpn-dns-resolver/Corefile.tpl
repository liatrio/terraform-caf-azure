.:53 {
    errors
    ready
    health
    forward . ${upstream_dns_server}
    cache 30
    loop
    reload
}
