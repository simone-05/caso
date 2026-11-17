# File con miei alias, incluso dal bashrc
# Per rendere effettive le modifiche fai ">source ~/.bashrc"
# alias a="xmodmap $HOME/xmodmaprc"
alias quit="echo sto uscendo... && sleep 1 && exit"
alias mirko="echo miao"
alias graph="git log --all --oneline --decorate --graph"
alias gits="git status"
alias gitaa="git add -A"
alias gitac="git add -A && git commit"
alias batt="upower -d|grep \"percentage\\|state\\|time to\"|head -n 3"
alias ltr="l -tra"

# Per comparare due file ma colorato e piu' ordinato
mydiff() {
    diff --color -u "$@"
}

#alias per cd e ls contemporaneamente
cl() {
    builtin cd "$@" && ls -CF
}

# My custom autocomplete suggestions function, see after for the 3 variants:
# _fuzzy_complete_files()       for commands that only autocomplete with files
# _fuzzy_complete_dirs()        for just directories
# _fuzzy_complete_both()        for both files and dirs

_fuzzy_complete() {
    local curr_word="${COMP_WORDS[COMP_CWORD]}"
    local complete_type="$1"  # "file", "dir", or "both"

    # Expand tilde
    [[ "$curr_word" == ~* ]] && curr_word="${curr_word/#\~/$HOME}"

    # Split directory and base name
    local dir_part="" base_part="$curr_word"
    [[ "$curr_word" == */* ]] && dir_part="${curr_word%/*}/" && base_part="${curr_word##*/}"

    # Gather entries based on type
    local entries=()
    if [[ -n "$dir_part" && -d "$dir_part" ]]; then
        local find_type=""
        [[ "$complete_type" == "dir" ]] && find_type="-type d"
        [[ "$complete_type" == "file" ]] && find_type="-type f"
        [[ "$complete_type" == "both" ]] && find_type=""

        while IFS= read -r -d '' e; do
            [[ "$e" == "$dir_part" ]] && continue
            entries+=("${e#./}")
        done < <(find "$dir_part" -maxdepth 1 $find_type -print0 2>/dev/null | sed -z 's|^\./||')
    else
        if [[ "$complete_type" == "file" ]]; then
            entries=($(compgen -f))
        elif [[ "$complete_type" == "dir" ]]; then
            entries=($(compgen -d))
        else  # both
            entries=($(compgen -f))
            entries+=($(compgen -d))
        fi
    fi

    # Normalize: lowercase, remove _ and -
    _normalize() { echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d '_-'; }

    # 1️⃣ Exact prefix match
    local prefix_matches=()
    for e in "${entries[@]}"; do
        local name="${e##*/}"
        [[ "${name,,}" == "${base_part,,}"* ]] && prefix_matches+=("$e")
    done

    if [[ ${#prefix_matches[@]} -gt 0 ]]; then
        COMPREPLY=("${prefix_matches[@]}")
        return
    fi

    # 2️⃣ Normalized fuzzy match
    local norm_input=$(_normalize "$base_part")
    local fuzzy_matches=()
    for e in "${entries[@]}"; do
        local name="${e##*/}"
        [[ "$(_normalize "$name")" == *"$norm_input"* ]] && fuzzy_matches+=("$e")
    done

    COMPREPLY=("${fuzzy_matches[@]}")
}

# Wrapper functions for autocompleter
# Specify file for commands that only autocomplete files (not directories)
# Specify dir for commands only for directories, or else both
_fuzzy_complete_files() { _fuzzy_complete file; }
_fuzzy_complete_dirs()  { _fuzzy_complete dir; }
_fuzzy_complete_both()  { _fuzzy_complete both; }

# Setup completions
complete -o filenames -F _fuzzy_complete_both vim
complete -o filenames -F _fuzzy_complete_dirs cl
complete -o filenames -F _fuzzy_complete_both cat


alias clu="cl .."

alias prettyjson="python -m json.tool"
alias dusort="du -had1 | sort -h"
alias dush="du -sh"
evinced() {
    evince "$@" &>/dev/null & \
    exit
}
alias merhaba="echo amına koyayım"
alias aşkım="echo belinay"
gripp() {
    grip --user-content --wide --quiet -b "$@" &
}
alias apos="flatpak run org.gnome.gitlab.somas.Apostrophe"
alias django="source ~/.virtualenvs/djangodev/bin/activate" # Per caricare il virtual environment python di django
alias djrun="python3 manage.py runserver" # Per runnare il server django
alias djtest="coverage run --source='.' manage.py test && coverage html" # Runna test e test coverage per l'app django in cui ci troviamo
alias djopentest="xdg-open htmlcov/index.html" # Apre la pagina index.html nel browser con i risultati del coverage
alias flaskenv="source ~/.virtualenvs/flask/bin/activate" # Per caricare il virtual environment python di flask
alias springrun="./mvnw spring-boot:run" # Per runnare progetti springboot con autoreload
alias mucomp="source ~/programmi/tesi/mucomp-venv/bin/activate" # Per caricare il virtual environment python della repo mulearn compare
alias tfenv="source ~/.virtualenvs/tf-env/bin/activate" # Per caricare il virtual environment python con tensorflow e uso di gpu

pyserve() {
    python3 -m http.server "$@"
}

ru() {
    ./a.sh "$@"
}

rub() {
    ./b.sh "$@"
}

# Avvio vscode usando il mio profile custom 'fast' che ha minime estensioni attive (ad esempio non ha quelle di java)
codef() {
    code --profile fast "$@"
}
# Avvio vscode usando il profile di default 'Default'
coded() {
    code --profile Default "$@"
}

gdbi() {
    gdb --x ~/.gdbinit "$@"
}

nv() {
    nvim "$@"
}

untar() {
    tar --one-top-level -xf "$@"
}

# apri il browser tor
alias tor="cd ~/myApps/tor-browser && ./start-tor-browser.desktop && exit"
alias nvin="nv ~/.config/nvim/init.lua +230"

py() {
    python3 "$@"
}
# Per ottenere anche le "tab completion" come quelle per python ovvero solo per i file in .py e cartelle:
complete -f -o plusdirs -X '!*.py' py

grepi() {
    grep -i "$@"
}

# come fare un ctrl c da output sul terminale
alias cpy="xclip -selection clipboard"
# come fare un ctrl v su input del terminale
alias pst="xclip -selection clipboard -o"

# android environment
alias andenv="source $HOME/tool_e_programmi_cli/per_applicazioni_mie
/android_env.sh"
# mio script di generazione di progetto android in kotlin
alias android-app-init="source $HOME/tool_e_programmi_cli/per_applicazioni_mie/new_project.sh"

# firebase pwa environment
alias firenv="source $HOME/tool_e_programmi_cli/per_siti_firebase/firebase_env.sh"
# mio script di generazione di progetto firebase per pwa
alias firebase-pwa-init="source $HOME/tool_e_programmi_cli/per_siti_firebase/firebase_env.sh"

# Mount windows C drive to /mnt/windowsC with owner "ollama",
# so that it can access the models in c/ollama_models/
_ollama_mount_models_win_partition() {
    local WINDOWS_DEVICE="/dev/nvme0n1p2"
    local WINDOWS_MOUNTPOINT="/mnt/windowsC"
    local OLLAMA_USER="ollama"

    local OLLAMA_UID=$(id -u "$OLLAMA_USER")
    local OLLAMA_GID=$(id -g "$OLLAMA_USER")

    # Mount if necessary
    if ! mountpoint -q "$WINDOWS_MOUNTPOINT"; then
        echo "Mounting Windows partition..."

        sudo mkdir -p "$WINDOWS_MOUNTPOINT"

        sudo mount -t ntfs3 \
            -o uid="$OLLAMA_UID",gid="$OLLAMA_GID",umask=022 \
            "$WINDOWS_DEVICE" "$WINDOWS_MOUNTPOINT" || return 1
    else
        echo "Windows partition already mounted. Skipping mount."
    fi
}

# Start ollama by the service (so in background)
ollamad() {
    _ollama_mount_models_win_partition || return 1
    # Start Ollama
    echo "Starting Ollama..."
    sudo systemctl start ollama
    # Show status
    sudo systemctl status ollama --no-pager | head -n 5
}

# Start ollama showing the server log
ollamaserve() {
    _ollama_mount_models_win_partition || return 1
    # Start Ollama
    echo "Starting Ollama..."

    # Stop systemd instance to avoid port conflicts
    sudo systemctl stop ollama

    # Start with user=ollama and set models folder
    sudo -u ollama env \
        OLLAMA_MODELS="/mnt/windowsC/ollama_models" \
        ollama serve
}

ollamastop() {
    echo "Stopping Ollama..."
    sudo systemctl stop ollama || return 1

    if mountpoint -q /mnt/windowsC; then
        echo "Unmounting /mnt/windowsC..."
        sudo umount /mnt/windowsC || {
            echo "ERROR: Could not unmount /mnt/windowsC. Something is still using it."
            return 1
        }
        echo "Partition successfully unmounted."
    else
        echo "Partition is already unmounted."
    fi

    echo "Ollama stopped and Windows partition unmounted!"
}

tlm() {
    OLLAMA_HOST=http://localhost:11434 command tlm "$@"
}

ai() {
    local model
    model=$(curl -s http://localhost:11434/api/ps | jq -r '.models[0].name')

    if [[ -z "$model" || "$model" == "null" ]]; then
        echo "No model currently running in Ollama."
        return 1
    fi

    ollama run "$model" "$@"
}
