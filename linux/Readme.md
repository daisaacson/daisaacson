# Readme

## Trusted Root CAs

After [eMudra's private key compromise](https://www.theregister.com/security/2026/10/20/indian-certification-authority-emudhras-private-keys-compromised-one-of-them-was-the-number-4/5304312), why trust so many CA's I'll likely never use? Only trust the [top 5 Certificate Authorities](https://technologychecker.io/blog/certificate-authority-market-share#who-are-the-top-5-certificate-authorities).

### Fedora

```shell
sudo find /etc/pki/ca-trust/extracted/pem/directory-hash/ -type f -not -regex ".*\(ISRG\|GTS\|Sectigo\|Amazon\|Go_Daddy\|DigiCert\|Microsoft\|SSL.com\|IdenTrust\).*.pem" | sudo xargs -I {} mv {} /etc/pki/ca-trust/source/blocklist/
sudo update-ca-trust
```