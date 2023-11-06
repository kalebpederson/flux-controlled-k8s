# package must be named signature and must result in an allow value
# for cosign to accept its result.
package signature

default allow := false

allow {
    input._type == "https://in-toto.io/Statement/v0.1"
    input.predicateType == "https://github.com/kalebpederson/schemas/code-coverage"
    input.predicate["code-coverage-units"] == "percent"
    input.predicate["code-coverage"] >= 85.0
}
