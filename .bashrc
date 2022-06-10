#!/usr/bin/env bash

## Sources
### bash-completion@2 brew formula
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

### aliases
if [ -f "${HOME}"/.bash_aliases ]; then
	source "${HOME}"/.bash_aliases
fi
