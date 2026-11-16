# Dependency map — what breaks when what breaks

Write the **critical chain** first, one line per link, in the order it actually fails:

```text
domain  ->  DNS  ->  hosting  ->  code repo  ->  email  ->  payments  ->  customer records  ->  bookkeeping
```

For each link: what it is, who controls it, what happens downstream when it fails, and the first safe
step a stranger would take.

| Link | Service | Who controls | Breaks if lost | First safe step |
|---|---|---|---|---|
| domain | | | nothing resolves | |
| dns | | | domain points nowhere | |
| hosting | | | sites down | |
| code | | | no deploys, no fixes | |
| email | | | password resets stop, customers get silence | |
| payments | | | cash stops | |
| customer records | | | orders/service cannot be delivered | |
| bookkeeping | | | filings and visibility of cash | |
