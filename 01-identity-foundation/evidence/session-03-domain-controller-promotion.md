# Session 3 Evidence: Domain Controller Promotion

## Goal
Promote `DC01` into the ATLAS Active Directory forest using `corp.atlas.test` and verify core domain controller functionality.

## Final state
- Domain controller: `DC01`
- Domain/forest DNS name: `corp.atlas.test`
- NetBIOS name: `ATLAS`
- DC01 IP: `10.10.20.10`
- Gateway: `10.10.20.1`
- DNS client/server: `10.10.20.10`
- OS: Windows Server 2025 Datacenter Evaluation
- Installed roles: AD DS and DNS
- Domain mode: `Windows2025Domain`
- Forest mode: `Windows2025Forest`
- FSMO roles: held by `DC01`
- Global Catalog: `DC01.corp.atlas.test`

## Validation evidence
- DNS zones observed: `corp.atlas.test` and `_msdcs.corp.atlas.test`
- Core services observed running: DNS, KDC, and Netlogon
- `SYSVOL` and `NETLOGON` shares exist
- SRV lookup for `_ldap._tcp.dc._msdcs.corp.atlas.test` resolved to `dc01.corp.atlas.test` / `10.10.20.10`
- AD object creation was verified by creating `TEST-OU`
- Deleting `TEST-OU` initially failed due to accidental deletion protection, confirming expected AD behavior

## Notes on dcdiag historical warnings
`dcdiag /q` still reported historical promotion-time warning events from 04:43. Functional validation passed after promotion and time synchronization remediation.

## Security/privacy note
DSRM password and administrative credentials are not stored in this evidence file.
