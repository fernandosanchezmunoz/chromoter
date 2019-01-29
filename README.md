Chromoter
=========

This is a Debian slim image running an X server with xfce4 and sharing the desktop through Google Chrome Remote Desktop.

## Use Cases

1. Provide system application accessible over the web easily.

2. Create a use & throw linux envinronment with GUI over cloud or any VPS /Server or  at your laptop. 

3. Multi-user environments that need isolation and privacy.

## How to use

### Ensure required traffic is allowed through your firewall. 
Permit:
- outbound UDP traffic
- inbound UDP responses
- traffic on TCP ports 443 (HTTPS) and 5222 (XMPP)

### Generate a Google Chrome Remote Desktop Code
- Go to https://remotedesktop.google.com/headless
- Select "Set up computer through Command Line"
- Authenticate with a Google account (Gmail or your corporate account if you use Google for email)
- Authorize Google Remote Access
- You should get a message that looks like
```
/opt/google/chrome-remote-desktop/start-host --code="4/XXXXX_BIG_CODE_HERE_XXXXX" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=
```
- Copy the entire "Big Code" including the "4/CODE_HERE"
- Run from Command Line:

```
export CODE=[PASTE_YOUR_CODE_HERE]
docker run -td -p 443:443 -p 5222:5222 fernandosanchez/chromoter
```

- Wait until the instance boots, then visit:
https://YOUR_HOSTS_PUBLIC_IP

