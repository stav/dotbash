# exports.bash: executed by profile.bash

# Add `~/bin` to the `$PATH` : this is double dipping from ~/.profile
# export PATH="$HOME/bin:$PATH";

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE="$HISTIGNORE:c:h:l:ll:reset"

# Grep color
# # Make grep patterns a color that looks better than the default red on dark themes
# # http://unix.stackexchange.com/questions/148#answer-174
# GREP_COLOR='1;30'  # grey
# GREP_COLOR='0;36'  # blue
GREP_COLOR='1;32'  # green
export GREP_COLORS="ms=${GREP_COLOR}:mc=${GREP_COLOR}:ln=33"

# Helper to add directories to PATH only if not already present
add_to_path_if_missing() {
  for dir in "$@"; do
    case ":$PATH:" in
      *":$dir:"*) ;;
      *) PATH="$dir:$PATH" ;;
    esac
  done
  export PATH
}

# Deno
export DENO_INSTALL="$HOME/.deno"
add_to_path_if_missing "$DENO_INSTALL/bin"

# Flutter
export CHROME_EXECUTABLE=/var/lib/snapd/snap/bin/chromium

# Gradle
export JAVA_HOME="$HOME/Applications/android-studio/jbr"

# Perl
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
add_to_path_if_missing "$HOME/perl5/bin"

# Bun
export BUN_INSTALL="$HOME/.bun"
add_to_path_if_missing "$BUN_INSTALL/bin"

# Fly
export FLYCTL_INSTALL="$HOME/.fly"
add_to_path_if_missing "$FLYCTL_INSTALL/bin"

# Pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
add_to_path_if_missing "$PNPM_HOME"

# Go
export GOPATH="$HOME/go"
add_to_path_if_missing "$GOPATH/bin"

# Vapi
export VAPI_INSTALL="$HOME/.vapi"
export MANPATH=""$HOME/.vapi"/share/man:$MANPATH"
add_to_path_if_missing "$VAPI_INSTALL/bin"
