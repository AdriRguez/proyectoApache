$TTL    3600   
@       IN      SOA     ns.fabulas.com. adrian.danielcastelao.org. (
                   2022051001           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      ns.fabulas.com.
ns      IN      A       10.2.0.3
oscuras      IN      A       10.2.0.254
maravillosas   IN      CNAME   oscuras