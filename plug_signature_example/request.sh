#!/usr/bin/env bash

# base64 output differs between Linux and OS X
case $(uname) in
Darwin)
    base64_args=""
    ;;
Linux)
    base64_args="-w0"
    ;;
esac

usage () {
    cat << EOF
Usage: $0 [<scenario> [<method>]]

  Scenarios: valid | expired | digest | key | headers | signature | rsa | hmac
  Methods: post | get

EOF
    exit 1
}

scenario=${1:-valid}
method=${2:-post}

host=localhost:4040
params="query=test"
headers="(request-target) (created) host digest"
private_key=priv/ec.key
key_id=ec.pub

case ${method,,} in
post)
    request="/"
    body="${params}"
    ;;
get)
    request="/?${params}"
    body=""
    ;;
*)
    usage
    ;;
esac

body_sha256=$(echo -ne "${body}" | openssl dgst -sha256 -binary | base64 ${base64_args})
digest="sha-256=${body_sha256}"

created=$(date +%s)

case ${scenario,,} in
valid)
    ;;
expired)
    created=$(date -v -10M +%s)
    ;;
digest)
    digest="sha-256=v7s8tN6onk17uf3xx9VzMFXenFUkD5G7Yog1laUcjuA="
    ;;
key)
    key_id=unknown.pub
    ;;
headers)
    headers="(request-target) (created) host"
    override_signature=$(echo -ne "(request-target): ${method,,} ${request}\n(created): ${created}\nhost: ${host}" | \
        openssl dgst -sha512 -sign ${private_key} | \
        base64 ${base64_args})
    ;;
signature)
    override_signature=$(echo -ne "(request-target): ${method,,} /invalid\n(created): ${created}\nhost: ${host}\ndigest: ${digest}" | \
        openssl dgst -sha512 -sign ${private_key} | \
        base64 ${base64_args})
    ;;
rsa)
    private_key=priv/rsa.key
    override_signature=$(echo -ne "(request-target): ${method,,} ${request}\n(created): ${created}\nhost: ${host}\ndigest: ${digest}" | \
        openssl dgst -sha512 -sigopt rsa_padding_mode:pss -sign ${private_key} | \
        base64 ${base64_args})
    key_id=rsa.pub
    ;;
hmac)
    hmac_secret=$(cat priv/hmac.key)
    override_signature=$(echo -ne "(request-target): ${method,,} ${request}\n(created): ${created}\nhost: ${host}\ndigest: ${digest}" | \
        openssl dgst -hmac ${hmac_secret} -sha512 -binary | \
        base64 ${base64_args})
    key_id=hmac.key
    ;;
*)
    usage
    ;;
esac

signature=$(echo -ne "(request-target): ${method,,} ${request}\n(created): ${created}\nhost: ${host}\ndigest: ${digest}" | \
    openssl dgst -sha512 -sign ${private_key} | \
    base64 ${base64_args})

case ${method,,} in
post)
    curl -v \
        -d ${body} \
        -H "Digest: $digest" \
        -H "Authorization: Signature keyId=${key_id},signature=\"${override_signature:-$signature}\",headers=\"${headers}\",created=${created}" \
        "http://${host}${request}"
    ;;
get)
    curl -v \
        -H "Digest: $digest" \
        -H "Authorization: Signature keyId=${key_id},signature=\"${override_signature:-$signature}\",headers=\"${headers}\",created=${created}" \
        "http://${host}${request}"
    ;;
esac
