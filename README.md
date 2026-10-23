# Enterprise Active Directory & Security Telemetry Home Lab

## 📌 Project Overview
The objective of this project is to simulate an enterprise Windows domain environment to gain practical experience in identity and access management (IAM), Group Policy administration, baseline auditing, and security telemetry generation for SOC monitoring.

---

## 🏗️ Architecture & Network Topology

| Hostname | Operating System | Role | IP Address |
| :--- | :--- | :--- | :--- |
| **DC-01** | Windows Server 2022 | Domain Controller, DNS, DHCP | `192.168.10.10/24` |
| **WS-01** | Windows 10/11 Enterprise | Domain-Joined Client Workstation | `192.168.10.20/24` |
| **SIEM-01** | Ubuntu 22.04 LTS / Windows | Splunk Enterprise Log Collector | `192.168.10.50/24` |

*(Insert your network diagram image here: `![Network Architecture](./network-topology.png)`)*

---

## 🛠️ Tools & Technologies Used
- **Hypervisor:** Oracle VirtualBox / VMware Workstation
- **Directory Services:** Active Directory Domain Services (AD DS)
- **Policy Management:** Group Policy Management Console (GPMC)
- **Scripting:** PowerShell (ActiveDirectory Module)
- **Monitoring & Telemetry:** Microsoft Sysmon, Splunk Universal Forwarder

---

## 🚀 Implementation Walkthrough

### Phase 1: Domain Controller & Active Directory Setup
1. Installed Windows Server 2022 in an isolated NAT/Internal network.
2. Promoted the server to Domain Controller for domain `corp.local`.
3. Configured static IP and integrated DNS forwarding.
4. Created an enterprise Organizational Unit (OU) hierarchy:
   - `Corp_Root` > `Departments` (IT, Operations, Finance) > `Users` and `Computers`.

### Phase 2: Automated User Provisioning via PowerShell
To replicate a production enterprise, I wrote and executed a PowerShell automation script (`./scripts/Create-ADUsers.ps1`) to bulk-generate 25+ users across multiple departments with randomized titles and standard security groups.

### Phase 3: Group Policy Hardening & Security Baselines
Implemented custom Group Policy Objects (GPOs) applied to root and department OUs:
- **Account Lockout Policy:** 5 invalid logon attempts initiates a 30-minute lockout window.
- **Advanced Audit Policies:** Enabled auditing for:
  - Account Logon (`Event ID 4624` - Success, `4625` - Failure)
  - Process Creation (`Event ID 4688`) with command-line auditing enabled
  - Security Group Changes (`Event ID 4728`, `4732`)
- **Local Administrator Restrictions:** Denied local administrative rights to standard domain user accounts.

### Phase 4: Endpoint Integration & Telemetry Deployment
1. Joined `WS-01` (Windows workstation) to the `corp.local` domain and verified user login authentication.
2. Deployed **Microsoft Sysmon** with a hardened community configuration (`sysmonconfig.xml`) to capture process spawning, file hashes, and network connections.
3. Configured log forwarding into Splunk to verify centralized event capture for threat detection.

---

## 🧪 Verification & Threat Simulation Tests

| Test Scenario | Executed Action | Observed Event ID / Artifact | Status |
| :--- | :--- | :--- | :--- |
| **Brute Force Detection** | Simulated repeated wrong passwords on a domain account | `Event ID 4625` logged with Sub Status `0xC000006A` | ✅ Verified |
| **Privilege Escalation** | Added a standard user to Domain Admins via CLI | `Event ID 4728` generated in Security Log | ✅ Verified |
| **Process Spawning** | Launched PowerShell command with encoded parameters | Sysmon `Event ID 1` captured CLI arguments & parent PID | ✅ Verified |

---

## 📸 Key Documentation Screenshots

*(Add your screenshots here with brief captions)*

- **Active Directory Users and Computers (ADUC) Hierarchy:**  
  `![ADUC OU Layout](./screenshots/01-ad-domain-controller.png)`
- **Group Policy Advanced Auditing Configuration:**  
  `![Group Policy Management](./screenshots/02-gpo-audit-policy.png)`
- **Event Log Verification:**  
  `![Event ID 4625 Capture](./screenshots/04-splunk-event-log.png)`

---

## 💡 Key Skills Demonstrated
- Enterprise Windows Server & Active Directory administration
- Role-Based Access Control (RBAC) and least privilege enforcement
- PowerShell scripting for systems automation
- Security auditing configuration and telemetry forwarding
