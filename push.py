#!/usr/bin/env python3
"""
push.py — Sube cambios directamente a GitHub via API (sin git push local).

Uso:
  python3 push.py                        # Commit con timestamp automático
  python3 push.py "mensaje de commit"    # Commit con mensaje personalizado

No requiere sincronización local de git. Funciona siempre.
"""

import os
import sys
import json
import base64
import subprocess
import datetime

REPO      = "pepitogumball-lang/Dynamic-Light"
REPO_URL  = f"https://github.com/{REPO}"
BRANCH    = "main"

# Directorios y extensiones a ignorar al subir
SKIP_DIRS = {".git", "build_verify", "attached_assets", "__pycache__", ".local", ".agents"}
SKIP_EXTS = {".png", ".jpg", ".jpeg", ".zip", ".mcaddon", ".mcpack", ".pyc"}

def gh_api(endpoint, method="GET", data=None, base="repos"):
    """Llama a la GitHub API via gh CLI."""
    url = f"{base}/{REPO}/{endpoint}" if base == "repos" else endpoint
    cmd = ["gh", "api", url, "-X", method, "--silent=false"]
    if data:
        cmd += ["--input", "-"]
    result = subprocess.run(
        cmd,
        input=json.dumps(data).encode() if data else None,
        capture_output=True
    )
    if result.returncode != 0:
        err = result.stderr.decode().strip()
        raise RuntimeError(f"GitHub API error ({endpoint}): {err}")
    return json.loads(result.stdout)

def collect_files():
    """Recolecta todos los archivos de texto del proyecto."""
    entries = []
    for root, dirs, files in os.walk("."):
        # Filtrar directorios ignorados
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS and not d.startswith(".")]
        for fname in files:
            if fname.startswith("."):
                continue
            ext = os.path.splitext(fname)[1].lower()
            if ext in SKIP_EXTS:
                continue
            full_path = os.path.join(root, fname)
            rel_path  = os.path.relpath(full_path, ".").replace("\\", "/")
            entries.append((rel_path, full_path))
    return entries

def create_blob(content_bytes):
    """Crea un blob en GitHub para el contenido dado."""
    encoded = base64.b64encode(content_bytes).decode()
    result  = gh_api("git/blobs", "POST", {"content": encoded, "encoding": "base64"})
    return result["sha"]

def main():
    # ── Mensaje de commit ────────────────────────────────────────────────────
    if len(sys.argv) > 1:
        msg = " ".join(sys.argv[1:])
    else:
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        msg = f"Actualización — {now}"

    print(f"\n🎮 Dynamic Light — Push via GitHub API")
    print(f"{'─'*42}")
    print(f"💬 Commit: \"{msg}\"")
    print()

    # ── Verificar que gh CLI está autenticado ────────────────────────────────
    check = subprocess.run(["gh", "auth", "status"], capture_output=True)
    if check.returncode != 0:
        print("❌ gh CLI no está autenticado.")
        print("   Ejecuta: gh auth login")
        sys.exit(1)

    # ── Obtener HEAD y tree base ──────────────────────────────────────────────
    print("📡 Obteniendo estado del repositorio...")
    ref        = gh_api(f"git/refs/heads/{BRANCH}")
    head_sha   = ref["object"]["sha"]
    base_commit = gh_api(f"git/commits/{head_sha}")
    base_tree  = base_commit["tree"]["sha"]
    print(f"   HEAD: {head_sha[:12]}...")

    # ── Recolectar archivos y crear blobs ────────────────────────────────────
    files = collect_files()
    print(f"📁 Subiendo {len(files)} archivos...")

    tree_entries = []
    for rel_path, full_path in files:
        try:
            content = open(full_path, "rb").read()
            sha = create_blob(content)
            tree_entries.append({
                "path": rel_path,
                "mode": "100644",
                "type": "blob",
                "sha": sha
            })
            print(f"   ✅ {rel_path}")
        except Exception as e:
            print(f"   ⚠️  {rel_path}: {e}")

    # ── Crear árbol ───────────────────────────────────────────────────────────
    print("\n🌲 Creando árbol de commits...")
    new_tree = gh_api("git/trees", "POST", {
        "base_tree": base_tree,
        "tree": tree_entries
    })
    print(f"   Tree: {new_tree['sha'][:12]}...")

    # ── Crear commit ──────────────────────────────────────────────────────────
    print("📦 Creando commit...")
    new_commit = gh_api("git/commits", "POST", {
        "message": msg,
        "tree":    new_tree["sha"],
        "parents": [head_sha]
    })
    print(f"   Commit: {new_commit['sha'][:12]}...")

    # ── Actualizar ref ────────────────────────────────────────────────────────
    print(f"🚀 Actualizando branch {BRANCH}...")
    gh_api(f"git/refs/heads/{BRANCH}", "PATCH", {
        "sha":   new_commit["sha"],
        "force": True
    })

    # ── Resultado ─────────────────────────────────────────────────────────────
    print()
    print("✅ ¡Push exitoso!")
    print(f"   Repositorio: {REPO_URL}")
    print(f"   Commit:      {new_commit['sha']}")
    print()
    print("   GitHub Actions está compilando el .mcaddon...")
    print("   Revisa el build con:")
    print("   gh run list --limit 3\n")

if __name__ == "__main__":
    main()
