## Lab Backlog

### DC01 — LDAP security policy warnings (Event IDs 3051, 3054)
Observed at DC startup. Directory configured to allow implicit owner privileges
and to not enforce per-attribute authorization during LDAP add operations.
Both flagged as "not secure" in event text. Not blocking current work.
Investigate and remediate before any production-adjacent use.
Reference: https://go.microsoft.com/fwlink/?linkid=2174032

### Initialize-AtlasDirectory.ps1 — groups and users written, not yet validated
Groups, users, and membership blocks are now written, with group and account
names matched against the existing AD objects (GG-Engineering, GG-Finance,
GG-Helpdesk, GG-LinuxAdmins). GG-LinuxAdmins is intentionally empty -
populated at Session 10. Script has not yet been run end-to-end against the
live ATLAS domain to confirm idempotency. Validate before Session 7 closure.
