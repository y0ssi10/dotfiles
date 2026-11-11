local client_id="$1"
local block_id="$2"
setopt pipefail

ghq_picker_fail() {
    print -u2 -r -- "$1"
    read -r '?Press Return to close the repository picker. '
    exit 1
}

for tool in ghq fzf rex jq fzf-preview-git; do
    command -v "$tool" >/dev/null || ghq_picker_fail "$tool not found on PATH"
done

local repos sessions labels
repos="$(ghq list --full-path)" || ghq_picker_fail "ghq list failed"
[[ -n "$repos" ]] || ghq_picker_fail "No repositories found; add one with ghq get"
sessions="$(rex ls --json)" || ghq_picker_fail "Could not list Rex sessions"
labels="$(jq -er '[.sessions[].label] | join("\n")' <<< "$sessions")" \
    || ghq_picker_fail "Could not parse Rex sessions"
local -a session_labels=("${(@f)labels}")

ghq_picker_source() {
    local dir display
    for dir in "${(@f)repos}"; do
        display="${dir:h:t}/${dir:t}"
        if (( ${session_labels[(Ie)$display]} )); then
            printf '%s\t%s\t\e[32m󰄲 %s\e[m\n' "$dir" "$display" "$display"
        else
            printf '%s\t%s\t\e[34m󰄱 %s\e[m\n' "$dir" "$display" "$display"
        fi
    done
}

local selected code
local -a fields
selected="$(ghq_picker_source | fzf --ansi --exit-0 --reverse \
    --delimiter=$'\t' --with-nth=3.. \
    --preview='fzf-preview-git {1}' --preview-window='right:60%')"
code=$?
if (( code == 1 || code == 130 )); then
    selected=""
else
    (( code == 0 )) || ghq_picker_fail "fzf failed with exit status $code"
fi
fields=("${(@ps:\t:)selected}")
rex -C "$client_id" do ghq_open "block=$block_id" "dir=${fields[1]}" "label=${fields[2]}" \
    || ghq_picker_fail "Could not open the selected repository"
