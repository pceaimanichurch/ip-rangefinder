for /l %i in (1,1,254) do @ping 10.1.10.%i -w 100 -n 1 | find "Reply"
