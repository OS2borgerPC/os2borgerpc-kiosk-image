# Ubuntu 24.04 Python package installation

## Problemstilling

Ubuntu 24.04 har en sikkerhedsfunktion, som forhindrer Python-packages i at blive installeret direkte i systemets Python-installation med `pip`.

Dette gav problemer i vores pipeline, hvor `install_client.sh` oprindeligt installerede `os2borgerpc-client` direkte med `pip`.

Den oprindelige installation var:

```bash
pip install "$PACKAGE_NAME==$LATEST_VERSION"
```

På Ubuntu 24.04 bliver denne type installation blokeret, fordi systemets Python-miljø er beskyttet mod direkte ændringer.

## Første forsøg: `--break-system-packages`

Det første forsøg på at løse problemet var at tilføje:

```bash
--break-system-packages
```

til `pip`-kommandoen:

```bash
pip --break-system-packages install "$PACKAGE_NAME==$LATEST_VERSION"
```

Dette gjorde det muligt at installere pakken direkte i systemets Python-miljø.

Løsningen blev dog ikke valgt, da den kan skabe problemer, hvis Ubuntu eller Python senere opdaterer systemets egne Python-packages. En package installeret direkte i systemets Python-miljø kan dermed komme i konflikt med Ubuntu's package management.

## Andet forsøg: `pipx`

I stedet blev `pipx` undersøgt.

`pipx` installerer Python-packages i separate, isolerede Python-miljøer. På den måde ændres systemets Python-installation ikke direkte.

Dette løste problemet med installationen, men skabte et nyt problem.

Vores `os2borgerpc-client` package indeholder ikke kun Python-kode. Det installerer også Bash-kommandoer, som efterfølgende scripts i pipeline'en skal kunne køre direkte.

Efter installation med `pipx` var disse kommandoer ikke tilgængelige på samme måde som ved den tidligere `pip`-installation.

### `pipx ensurepath`

`pipx` har kommandoen:

```bash
pipx ensurepath
```

som kan tilføje pipx's bin-directory til brugerens `PATH`.

Dette var ikke egnet til vores pipeline, fordi ændringen af `PATH` først bliver aktiv i en ny shell.

Det ville derfor kræve, at man åbnede en ny terminal eller loggede ud og ind igen, før de installerede kommandoer kunne findes.

Pipeline'en skal derimod kunne installere pakken og derefter køre kommandoerne **i samme shell-session**.

## Den endelige løsning

I stedet for at bruge `pipx ensurepath` blev pipx's bin-directory sat til `/usr/local/bin` ved hjælp af environment variable:

```bash
export PIPX_BIN_DIR=/usr/local/bin
```

Pakken installeres derefter med `pipx`:

```bash
pipx install "$PACKAGE_NAME==$LATEST_VERSION"
```

eller ved installation fra GitHub:

```bash
pipx install "git+$PACKAGE_NAME@$LATEST_TAG"
```

### Resultat

Python-pakken bliver stadig installeret i et isoleret `pipx`-miljø.

Package'ets kommandoer bliver samtidig placeret i:

```text
/usr/local/bin/
```

`/usr/local/bin/` er allerede en del af systemets `PATH`, så kommandoerne kan bruges med det samme uden at starte en ny shell.

Det betyder, at pipeline'en fortsat kan køre de installerede kommandoer direkte.

## Problem ved gentagen kørsel af `os2borgerpc_kiosk_setup`

Under fejlsøgningen blev der også fundet et separat problem i `os2borgerpc_kiosk_setup`.

Scriptet satte produktet i konfigurationsfilen med:

```bash
echo "os2_product: $PRODUCT" >> /etc/os2borgerpc/os2borgerpc.conf
```

`>>` betyder, at indholdet bliver **tilføjet** til den eksisterende fil.

Hvis `os2borgerpc_kiosk_setup` fejlede og blev kørt igen, ville den derfor tilføje endnu en kopi af konfigurationen.

Efter flere forsøg kunne filen eksempelvis indeholde:

```text
os2_product: os2borgerpc kiosk
os2_product: os2borgerpc kiosk
os2_product: os2borgerpc kiosk
```

Det gjorde fejlsøgning og gentagne kørsler vanskelige, da den gamle konfiguration skulle fjernes manuelt, før scriptet kunne køres igen.

### Løsning

`>>` blev ændret til `>`:

```bash
# Set product in configuration
PRODUCT="os2borgerpc kiosk"
echo "os2_product: $PRODUCT" > /etc/os2borgerpc/os2borgerpc.conf
```

`>` overskriver filens eksisterende indhold i stedet for at tilføje til det.

Scriptet kan derfor nu køres flere gange uden at skabe dublerede `os2_product`-værdier.

Dette gør det også betydeligt nemmere at genkøre scriptet efter en fejl under installationen.

> ⚠️ **Vigtigt: Kontroller andre scripts, der bruger konfigurationsfilen**
>
> Ændringen fra `>>` til `>` betyder, at `/etc/os2borgerpc/os2borgerpc.conf` nu **overskrives** i stedet for at få tilføjet en ny linje.
>
> Før ændringen tages i brug permanent, bør det derfor undersøges, om andre scripts skriver yderligere konfiguration til denne fil, så vi ikke overskriver noget, de har brug for.
>
> Der kom umiddelbart ingen fejl som følge af denne ændring, hvilket er godt.
>
> Hvis dette sidefix godkendes til ikke at skabe konflikter, kan det tilføjes.
>
> Ellers kan man lade det være med `>>`, så længe scriptet ikke skal køres flere gange på samme maskine.


## Samlet resultat

Pipeline'en kan nu køres gentagne gange under fejlsøgning uden manuel oprydning af Python-installationen eller OS2BorgerPC-konfigurationsfilen.

De vigtigste ændringer var:

* `pip` blev erstattet med `pipx`.
* `--break-system-packages` blev fjernet.
* `PIPX_BIN_DIR` sættes til `/usr/local/bin`.
* Package'ets kommandoer er dermed tilgængelige med det samme.
* `os2borgerpc_kiosk_setup` overskriver nu `os2borgerpc.conf` i stedet for at tilføje dubletter.
* Pipeline'en er dermed nemmere at genkøre efter fejl.
