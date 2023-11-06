# package must be named signature and must result in an allow value
# for cosign to accept its result.
package signature

default allow = false

allow {
    input._type == "https://in-toto.io/Statement/v0.1"
}


