#!/usr/bin/env python3
"""
push.py — Automatiza git add, commit y push para Dynamic Light addon.

Uso:
  python3 push.py                        # Commit con timestamp automático
  python3 push.py "mensaje de commit"    # Commit con mensaje personalizado
"""

import os
import sys
import subprocess
import datetime

REPO_HTTPS = "https://github.com/pepitogumball-lang/Dynamic-Light.git"
REPO_HTTPS_CLEAN = "https://github.com/pepitogumball-lang/Dynamic-Light.git"

def run(cmd, check=True, capture=False, silent=False):
    """Ejecuta un comando shell. Retorna (returncode, stdout) si capture=True."""
    result = subprocess.run(
        cmd, shell=True,
        stdout=subprocess.PIPE if capture else None,
        stderr=subprocess.PIPE if silent else None,
        text=True
    )
    if capture:
        return result.returncode, result.stdout.strip()
    return result.returncode, ""

def has_staged_changes():
    code, _ = run("git diff --cached --quiet", check=False)
    return code != 0

def has_unstaged_changes():
    code, out = run("git status --porcelain", check=False, capture=True)
    return bool(out.strip())

def main():
    # ── 1. Token ─────────────────────────────────────────────
    token = (
        os.environ.get("GITHUB_PERSONAL_ACCESS_TOKEN") or
        os.environ.get("GITHUB_TOKEN")
    )
    if not token:
        print("❌ Error: no se encontró GITHUB_PERSONAL_ACCESS_TOKEN ni GITHUB_TOKEN.")
        print("   Agrega el secret en la pestaña 'Secrets' de Replit.")
        sys.exit(1)

    # ── 2. Mensaje de commit ─────────────────────────────────
    if len(sys.argv) > 1:
        msg = " ".join(sys.argv[1:])
    else:
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        msg = f"Actualización — {now}"

    print(f"\n🎮 Dynamic Light — Push Automático")
    print(f"{'─'*40}")

    # ── 3. Configurar identidad git si no existe ─────────────
    run('git config user.email "bot@dynamic-light.addon" 2>/dev/null', check=False, silent=True)
    run('git config user.name "Dynamic Light Bot" 2>/dev/null', check=False, silent=True)

    # ── 4. git add . ────────────────────────────────────────
    if not has_unstaged_changes():
        print("ℹ️  No hay cambios en el repositorio.")
        print("   El .mcaddon ya está actualizado.\n")
        return

    print("📁 Añadiendo cambios...")
    code, _ = run("git add .", check=False)
    if code != 0:
        print("❌ Error en 'git add .'"); sys.exit(1)

    # ── 5. git commit ────────────────────────────────────────
    if not has_staged_changes():
        print("ℹ️  Nada nuevo para commitear (todos los archivos ya estaban en stage).")
    else:
        print(f"💬 Commit: \"{msg}\"")
        code, _ = run(f'git commit -m "{msg}"', check=False)
        if code != 0:
            print("⚠️  El commit no se pudo crear.")

    # ── 6. Configurar remote con token (temporal) ────────────
    repo_with_token = f"https://x-token:{token}@github.com/pepitogumball-lang/Dynamic-Light.git"
    run(f'git remote set-url origin "{repo_with_token}"', check=False, silent=True)

    # ── 7. git push ──────────────────────────────────────────
    print("🚀 Enviando a GitHub (branch: main)...")
    code, _ = run("git push origin main", check=False)

    # ── 8. Restaurar remote sin token ───────────────────────
    run(f'git remote set-url origin "{REPO_HTTPS_CLEAN}"', check=False, silent=True)

    # ── 9. Resultado ─────────────────────────────────────────
    if code == 0:
        print("✅ ¡Push exitoso!\n")
        print("   GitHub Actions está compilando el .mcaddon...")
        print("   Espera ~30 segundos y luego revisa el build:\n")
        print("   gh run list --limit 3")
        print("   gh run view --log  (para ver logs del último run)\n")
    else:
        print("❌ Error al hacer push.")
        print("   Verifica que el token tenga permisos de 'repo'.")
        sys.exit(1)

if __name__ == "__main__":
    main()
