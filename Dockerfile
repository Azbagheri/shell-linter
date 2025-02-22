ARG SHELLCHECK_VERSION=v0.10.0
FROM koalaman/shellcheck:${SHELLCHECK_VERSION} AS builder

FROM alpine:3.20.3

COPY --from=builder /bin/shellcheck /usr/local/bin/

RUN apk update && apk add --no-cache bash && \
    shellcheck --version && \
    bash --version

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]