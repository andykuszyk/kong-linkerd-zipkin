# Kong with Linkerd and Zipkin

## Components
### "Service"
A simple app that prints information about the request given to it.

```
curl -v localhost:8081
```

### Linkerd
A service mesh that forwards request to `service`.

```
curl -v localhost:8080
```

> Requests to `linkerd` should be the same as directly to `service`, except they will be augmented with Linkerd-specific headers.

### Kong
A gateway and proxy, forwarding requests to `linkerd`.

```
curl -v localhost:8000
```

> These requests will be routed through to `linkerd`.
