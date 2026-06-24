## Lab Backlog

### DC01 — LDAP security policy warnings (Event IDs 3051, 3054)
Observed at DC startup. Directory configured to allow implicit owner privileges
and to not enforce per-attribute authorization during LDAP add operations.
Both flagged as "not secure" in event text. Not blocking current work.
Investigate and remediate before any production-adjacent use.
Reference: https://go.microsoft.com/fwlink/?linkid=2174032
