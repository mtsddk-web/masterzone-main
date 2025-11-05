# Deployment Guide - MasterZone.edu.pl

## Szybkie wdrożenie

### Krok 1: Uruchom skrypt deployment
```bash
./deploy.sh
```

### Krok 2: Podaj dane FTP
Przy pierwszym uruchomieniu skrypt zapyta o:
- **FTP Host**: np. `ftp.zenbox.pl` lub adres podany przez Zenbox
- **FTP User**: nazwa użytkownika FTP
- **FTP Password**: hasło FTP
- **FTP Path**: ścieżka na serwerze, np. `/public_html` lub `/domains/masterzone.edu.pl/public_html`

### Krok 3: Zapisz dane (opcjonalnie)
Skrypt zapyta czy zapisać dane FTP w pliku `.env.deploy` - dzięki temu przy kolejnych deploymentach nie musisz podawać danych ponownie.

⚠️ **Bezpieczeństwo**: Plik `.env.deploy` jest w `.gitignore` i nie będzie commitowany do repo.

---

## Pliki wdrażane

Skrypt automatycznie wgrywa następujące pliki:
- `index.html` - główna strona
- `stats.json` - dane o liczbie członków
- `favicon.ico` - favicon
- `favicon-16x16.png` - favicon 16x16
- `favicon-32x32.png` - favicon 32x32
- `apple-touch-icon.png` - ikona Apple

---

## Workflow

### 1. Zmiany w kodzie
Edytuj pliki lokalnie (np. `index.html`)

### 2. Commit do GitHub
```bash
git add .
git commit -m "Opis zmian"
git push
```

### 3. Deploy na Zenbox
```bash
./deploy.sh
```

### 4. Weryfikacja
Otwórz https://masterzone.edu.pl i sprawdź zmiany (może być potrzebny hard refresh: Cmd+Shift+R)

---

## Troubleshooting

### Błąd: "command not found: lftp"
Skrypt automatycznie użyje `curl` jako fallback. Jeśli chcesz zainstalować `lftp`:
```bash
brew install lftp
```

### Błąd: "Login incorrect"
Sprawdź dane FTP w panelu Zenbox i uruchom ponownie z poprawnymi danymi.

### Pliki nie aktualizują się
- Wyczyść cache przeglądarki (Cmd+Shift+R)
- Sprawdź czy FTP Path jest poprawny
- Zweryfikuj czy pliki zostały wgrane w panelu Zenbox

---

## Gdzie znaleźć dane FTP?

1. Zaloguj się do panelu Zenbox.pl
2. Sekcja **FTP** lub **Menadżer plików**
3. Znajdź:
   - Host FTP
   - Login FTP
   - Możliwość resetowania hasła
   - Ścieżkę główną domeny (public_html)
