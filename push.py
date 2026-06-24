import os
import subprocess

def run_command(command):
    try:
        subprocess.run(command, check=True, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar: {command}\n{e}")

def main():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print("Error: GITHUB_TOKEN no encontrado en el entorno.")
        return

    run_command("git add .")
    run_command('git commit -m "Actualización automática de estado"')
    run_command("git push origin main")

if __name__ == "__main__":
    main()
