# ADR-001: Domain Namespace Selection

## Status
Accepted

## Context
Session 3 established the ATLAS Active Directory forest and domain on `DC01` using Windows Server 2025 Datacenter Evaluation. The lab required an internal DNS namespace suitable for portfolio documentation and repeatable hybrid identity work.

## Decision
Use `corp.atlas.test` as the domain and forest DNS name, with `ATLAS` as the NetBIOS name.

## Alternatives considered
- `atlas.test`
- `atlas.local`

## Rationale
`corp.atlas.test` separates the internal corporate namespace from the lab identity name while retaining clear alignment with ATLAS. The `.test` suffix is appropriate for a controlled lab namespace and avoids presenting the environment as a production public domain.

## Consequences
- Domain and forest DNS name: `corp.atlas.test`
- NetBIOS name: `ATLAS`
- DNS zones observed: `corp.atlas.test` and `_msdcs.corp.atlas.test`
- Domain mode: `Windows2025Domain`
- Forest mode: `Windows2025Forest`

## Validation
The namespace was validated after promotion by confirming that `_ldap._tcp.dc._msdcs.corp.atlas.test` resolved to `dc01.corp.atlas.test` at `10.10.20.10`.
