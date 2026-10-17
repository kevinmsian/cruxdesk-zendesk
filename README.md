# CruxDesk: Zendesk Support Environment

A Zendesk support environment for a fictional B2B SaaS company that sells gym management software to climbing gyms. Scenarios are based on my experience working in a climbing gym.

I created the company, wrote 31 customer tickets, configured routing, SLAs, macros, automations and a help center, then worked every ticket the way a support agent would: triage, reply, hand off, resolve.

## At a Glance

* 26 tickets worked and solved, including a Problem ticket with 4 linked Incidents
* 11 macros, 7 triggers, 2 automations
* 3 SLA policies by plan tier, measured in business hours
* 4 groups: Tier 1, Billing, Onboarding and Training, Escalations/Technical
* 3 custom fields (Plan Tier, Product Area, Issue Type) that automatically tag every ticket
* Help center with 4 sections and 5 articles
* Light agents set up for Account Management and Sales

## The Company

CruxDesk sells software that runs a climbing gym: memberships, point of sale, class scheduling, route setting and billing.

* Plans: Base ($165, 3 seats), Pro ($279, 8 seats), Summit ($395, 15 seats), Custom
* Annual prepay saves 15%
* Support hours: 6am to 10pm Pacific, 7 days a week

## Highlight 1: Fixing the Routing I Built

**The problem:** I designed the routing triggers to fire when a ticket is created. Testing showed that email tickets arrive with empty custom fields, so the routing rules had nothing to match and every email ticket stayed in Tier 1.

**The fix:** I changed Route technical, Route billing and Route onboarding to fire when a ticket is in the Tier 1 group instead of only at creation. Now an agent triages the ticket, fills in Product Area and Issue Type, and the ticket moves to the right group automatically. Default routing still runs at creation so nothing lands unassigned.

**Why it matters:** Routing that works on paper can fail on real channels. Testing with real ticket types found it before customers would have.

![Route technical trigger before](screenshots/041n.png)
![Route technical trigger after](screenshots/041o.png)

## Highlight 2: Handling a Payment Outage

A payment processor outage caused failed charges for multiple gyms at once. Instead of answering four customers separately:

1. Created one Problem ticket and linked all 4 customer Incidents to it
2. Published a help center article and updated it from Investigating to Resolved
3. Solved the Problem ticket, which solved all 4 Incidents and sent every customer the same update at once
4. Caught a placeholder greeting ("Hi Kevin") before the update went out to all four customers
5. Worked a follow up ticket afterward for a customer cleaning up affected transactions

![Problem ticket with four linked incidents](screenshots/072.png)
![All four customers notified at once](screenshots/075.png)

## Highlight 3: AI Triage vs Human Triage

Zendesk AI suggested an intent for each ticket. Several times the suggestion pointed at the symptom, not the cause:

* A ticket the AI labeled as a login problem was really a seat limit. I found a fix within the customer's current plan before suggesting an upgrade.
* A ticket the AI labeled as phishing was really a confirmed account breach. I marked it Urgent and walked the gym through forcing a password reset for all staff and turning on two factor authentication.
* A Klaviyo question the AI labeled as "Software usage instructions" was really a request for an integration CruxDesk doesn't support. I offered the Mailchimp integration as an alternative and logged it as the third Klaviyo request this quarter.

The AI was useful elsewhere: minutes after I published the outage article, it drafted a suggested reply based on that article.

## How I Worked Each Ticket

Every ticket has internal notes in the same pattern: **Triage, Handoff, Resolution.** A few examples of what that caught:

* **Checking the math:** A customer's annual discount wasn't applied to an upgrade. I calculated the overcharge ($104.40), issued the refund, and flagged it as a possible bug affecting other upgrades.
* **Fixing the source:** A refund follow up showed an outdated macro was promising the wrong timeline. I answered the customer and corrected the macro.
* **Silent failures:** A Mailchimp connection expired without warning and 47 members never synced. I escalated to Technical and logged a feature request for connection expiry alerts.
* **Security first:** A gym needed a terminated employee's access removed. I deactivated the account instead of deleting it, keeping the activity history.
* **Business hours SLAs:** A 24 hour target displayed a 32 hour badge because the SLA clock pauses overnight, which matches the policy as designed.
* **Sales handoff:** An upgrade inquiry triggered an automatic notification to the Sales light agent.

## Help Center

![Help center homepage](screenshots/126.png)

## Solved Queue

![Recently solved tickets](screenshots/125.png)

## Built With

Zendesk Suite trial (Support, Guide, Explore, AI agents), October 2026.
