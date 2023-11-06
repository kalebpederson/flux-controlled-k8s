# package must be named signature and must result in an allow value
# for cosign to accept its result.
package signature

import future.keywords.if
import future.keywords.in

allow if {
	input._type == "https://in-toto.io/Statement/v0.1"
	input.predicateType == "https://cosign.sigstore.dev/attestation/vuln/v1"
	not unrecognized_severity
	not high_or_critical
}

high_or_critical if {
	disallowed_severities := {"HIGH", "CRITICAL"}
	some r
	some v
	input.predicate.scanner.result.Results[r].Vulnerabilities[v].Severity in disallowed_severities
}

unrecognized_severity if {
	recognized_severities := {"LOW", "MEDIUM", "HIGH", "CRITICAL"}
	some r
	some v
	input.predicate.scanner.result.Results[r]
	input.predicate.scanner.result.Results[r].Vulnerabilities[v]
	not input.predicate.scanner.result.Results[r].Vulnerabilities[v].Severity in recognized_severities
}
