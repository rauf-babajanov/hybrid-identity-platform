# ADLAB Network Design

## Purpose

The ADLAB network provides an isolated virtual environment for the Hybrid Identity Platform.

The network hosts Active Directory, Windows clients, Linux systems, and future hybrid identity components while remaining separated from the physical home network.

---

## Design Goals

* Isolated lab environment.
* Predictable IP addressing.
* Simple troubleshooting.
* Enterprise-style naming standards.
* Support for future growth.

---

## Network Definition

Network Name:

ADLAB

Network Address:

10.20.0.0/24

Subnet Mask:

255.255.255.0

Usable Hosts:

10.20.0.1 - 10.20.0.254

---

## Design Rationale

The 10.20.0.0/24 subnet was selected from the private 10.0.0.0/8 address space because it provides clear separation from common home network ranges, is easy to identify during troubleshooting, and leaves room for future network expansion.

---

## Planned Systems

### DC01

Role:

Active Directory Domain Controller

IP Address:

10.20.0.10

DNS:

10.20.0.10

---

### WS01

Role:

Windows Client

IP Address:

DHCP Reservation

DNS:

10.20.0.10

---

### LNX01

Role:

Linux Server

IP Address:

DHCP Reservation

DNS:

10.20.0.10

---

## DNS Design

All lab systems use the domain controller as their primary DNS server.

Primary DNS:

10.20.0.10

---

## Naming Standard

### Servers

DC01

### Windows Clients

WS01
WS02
WS03

### Linux Systems

LNX01
LNX02

### Administrative Accounts

adm-firstname.lastname

### Service Accounts

svc-servicename

---

## Future Expansion

The network design must support:

* Additional Windows servers.
* Additional Linux systems.
* Microsoft Entra ID integration.
* Microsoft Intune integration.
* Security testing.
* Identity governance scenarios.

---

## Success Criteria

* Virtual network operational.
* Systems communicate successfully.
* DNS resolution operational.
* Active Directory deployment supported.
