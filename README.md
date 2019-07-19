# Kong with Linkerd and Zipkin

## Overview
The purpose of this repo is to try to establish end-to-end tracing of a request that enters a Kong gateway, is routed through Linkerd and ends up at an application (`service`). This is problematic, because normally Linkerd handles its own tracing separately from application tracing, encoding its own trace information in the `l5d-ctx-trace` header. Similarly, Kong can also handle its own tracing, placing its trace information in the [standard Zipkin headers](https://zipkin.io/pages/instrumenting.html). However, in a scenario such as this, the two traces (from Kong and Linkerd) are not connected. This repo aims to connect the two traces.

Connecting traces from Kong and Linkerd involves passing Linkerd a valid `l5d-ctx-trace` header that it will recognise as its own. This will result in Linkerd continuing the trace begun by Kong. In order to achieve this, we need to serialise Kong's tracing information in the same format expected by Linkerd. This process is discussed [here](https://github.com/linkerd/linkerd/issues/1428) and more information on how this is achieved in Linkerd can be found [here](https://github.com/twitter/finagle/blob/c4a301a003a87ba4aded3993a50c02dec95b1d8a/finagle-core/src/main/scala/com/twitter/finagle/tracing/TraceId.scala), [here](https://github.com/twitter/finagle/blob/c4a301a003a87ba4aded3993a50c02dec95b1d8a/finagle-core/src/main/scala/com/twitter/finagle/tracing/SpanId.scala) and [here](https://github.com/twitter/finagle/blob/c4a301a003a87ba4aded3993a50c02dec95b1d8a/finagle-core/src/main/scala/com/twitter/finagle/util/ByteArrays.scala).

The approach in this repo was to use a Kong plugin to write this Linkerd header in an acceptable format. As yet, this approach has been unsuccessful. Various problems are faced, such as the relatively old version of Lua in use by Kong (`5.1`), the lack of bitwise operators and support for 64-bit integers in this version and the lack of native binary support in the Lua standard library.

## Running the example in this repo
The simplest way to run the example in this repo is with `make test`. This will `docker-compose up` the compose file and send a test request to Kong, which can be repeated with `make request`. Note the two headers included in the downstream request (which is printed out by the terminal service): `x-foo`, which contains the custom header, and `l5d-ctx-trace`, which is the Linkerd replacement header.

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
