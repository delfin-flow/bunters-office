# Authority — who may legally do what, and where to stop

**This is a classification, not legal advice.** It exists so that a frightened person is told the truth
about their power instead of being handed a password and a wish.

## The six classes

| Class | Means | Who acts | The agent's job |
|---|---|---|---|
| `owner-only` | only the account holder can act | the owner, while able | record it; find the provider's own successor route if one exists |
| `company-alternate` | the entity has appointed a second authorised person | that person, per the provider's confirmation | record who, since when, and the confirmation evidence |
| `attorney-alive` | a registered power of attorney covers it **while the owner is alive** | the attorney, within the instrument's scope | record the instrument, the registration reference and its limits |
| `executor-after-death` | the personal representative acts for the estate | executor/administrator after the grant | record what the provider will require; never imply a login |
| `provider-decides` | the provider has its own discretionary process | the provider | record the exact route, evidence required and the date checked |
| `professional-step` | a solicitor, accountant, bank or court must act | that professional | stop, name the professional, and refer |

An entry with no class is `unknown` — and `unknown` blocks the pack from claiming that link works.

## Hard stops (never crossed, at any speed)

- **No impersonation.** Logging in as, signing as, or speaking as another person is not a shortcut; it is
  unauthorised access (Computer Misuse Act 1990) and, in a business context, often fraud.
- **Powers of attorney end at death.** An LPA (England & Wales) or a Continuing/Welfare PoA (Scotland)
  authorises a person while the granter is alive; after death it is the executor/administrator, and in
  Scotland that means **confirmation**, not probate.
- **A sole trader's trade normally ceases at death** (HMRC TSEM6056 / BIM80570). "Keep trading as
  before" is not available by default. A partnership dissolves by default (Partnership Act 1890 s33)
  unless the agreement says otherwise. A limited company is a separate legal entity — its articles,
  shareholder agreement and bank mandate decide who may act, and inheriting shares does not confer
  either directorship or bank access.
- **Accounts are licensed, not owned.** Record owned asset / licence / service identity / provider-held
  data separately, because the platform's terms, not the estate, decide what transfers.
- **No universal payable-on-death designation in the UK**, joint-account survivorship differs in
  Scotland, and pension nominations are usually discretionary — record the form, the scheme rule and the
  date, never a promise.
- **A letter of authority is not a power of attorney** and does not survive death. Keep the copy and the
  provider's confirmation of its scope.
- **UK GDPR outlives the owner.** Customer and staff data stays protected; the controller may change
  (e.g. an executor for a sole trader) and a wholesale export to a relative is not permitted.
- **Reserved legal activities** (probate work, reserved instruments) belong to regulated professionals
  (Legal Services Act 2007). Drafting a *request* to a solicitor is fine; drafting the instrument is not.

## Jurisdiction is a field, not an assumption

Ask early, store in `store/settings.yaml`, and never show England & Wales wording to a Scottish user
(or the reverse). Where the answer is not known, the record says `unknown` and the procedure says
"confirm with a solicitor in <jurisdiction>".
