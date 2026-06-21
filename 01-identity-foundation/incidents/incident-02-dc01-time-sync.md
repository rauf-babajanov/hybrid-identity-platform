# Incident-02: DC01 Time Synchronization

## Situation
During Session 3, `DC01` showed incorrect time and reported `Local CMOS Clock` as its time source.

## Task
Restore reliable time synchronization for the domain controller and confirm the corrected source.

## Evidence
- Affected system: `DC01`
- Role context: domain controller and PDC Emulator for `corp.atlas.test`
- Initial time source: `Local CMOS Clock`
- Observed impact: incorrect system time

## Diagnosis
`DC01` was not using an external NTP source. As the PDC Emulator, it needed to provide reliable time for the domain.

## Action
Configured external NTP peers for the Windows Time Service and marked `DC01` / PDC Emulator as a reliable time source.

## Result
`w32tm /query /source` returned an external NTP source, and the time became correct. Functional domain controller tests passed.

## Root cause
`DC01` was relying on `Local CMOS Clock` instead of external NTP peers.

## Prevention / lesson
Validate Windows Time Service source after domain controller promotion, especially on the PDC Emulator, before relying on downstream domain time behavior.
