# Session 06 – Client Networking and Active Directory Domain Join

## Objective

Establish WS01 as a correctly addressed Windows client on the `adlab` network and join it to the `corp.atlas.test` Active Directory domain using DC01-provided DNS discovery.

## Architectural Capability Added

Session 06 added the first domain-joined client endpoint to the identity foundation. WS01 now participates in the `corp.atlas.test` domain as a Windows 11 Enterprise Evaluation workstation with a validated computer account in Active Directory.

## Engineering Decisions

- WS01 was renamed correctly before domain join to ensure the workstation identity matched the intended asset name.
- WS01 was assigned a static IPv4 configuration because DHCP is intentionally disabled on `adlab`.
- The final client network configuration is:
  - IPv4: `10.10.20.50/24`
  - Gateway: `10.10.20.1`
  - DNS: `10.10.20.10` only
- DC01 is the sole DNS resolver for WS01 because Active Directory domain discovery depends on domain DNS records, not generic name resolution.
- Troubleshooting followed the dependency chain: virtual NIC → IP/routing → DNS → SRV discovery → domain join.

## Validation Evidence

- WS01 no longer depended on APIPA addressing; the earlier `169.254.x.x` address indicated the client had no usable IPv4 configuration before static addressing was applied.
- `corp.atlas.test` resolved to `10.10.20.10`.
- The LDAP SRV record resolved to `dc01.corp.atlas.test` on port `389`.
- WS01 successfully joined `corp.atlas.test`.
- DC01 confirmed the WS01 computer account:
  - Distinguished name: `CN=WS01,CN=Computers,DC=corp,DC=atlas,DC=test`
  - `DNSHostName`: `WS01.corp.atlas.test`
  - `OperatingSystem`: `Windows 11 Enterprise Evaluation`
  - `SamAccountName`: `WS01$`

## Engineering Lessons

- DNS is a required control-plane dependency for Active Directory domain discovery.
- Ping alone is not sufficient validation for a domain join path; ICMP reachability does not prove DNS correctness or service discovery.
- SRV records matter because clients locate domain services through records such as LDAP over TCP, not just through host A records.
- APIPA addressing is a useful signal that client IPv4 provisioning has failed or is absent.
- Validating each dependency layer in order reduces guesswork and prevents treating domain join failures as isolated authentication issues.

## Outcome

WS01 is correctly named, statically addressed, using DC01-only DNS, and joined to `corp.atlas.test`. The lab now has a validated Active Directory client endpoint ready for subsequent identity, policy, and endpoint-management work.
