# vim:et sts=2 sw=2 ft=zsh
#
# A simple theme that displays relevant, contextual information.
#
# A simplified fork of the original sorin theme from
# https://github.com/sorin-ionescu/prezto/blob/master/modules/prompt/functions/prompt_sorin_setup
#
# Requires the `prompt-pwd` and `git-info` zmodules to be included in the .zimrc file.

#
# 16 Terminal Colors
# -- ---------------
#  1 red
#  2 green
#  3 yellow
#  4 blue
#  5 magenta
#  6 cyan
# default white
#

_prompt_couloum_vimode() {
  case ${KEYMAP} in
    vicmd) print -n '%F{red}[vi]%f' ;;
    *) print -n '' ;;
  esac
}

_prompt_couloum_keymap_select() {
  zle reset-prompt
  zle -R
}

function _prompt_couloum_color_hostname {
  if [ "$USER" = "root" ]; then
    COLOR="red"
  else
    COLOR="magenta"
  fi

  # Make Sure we get only the hostname
  SERVER=$(hostname -s)

  # Detect VadeSecure style hostname and color in white platform name
  # Or symply color full hostname in its short form
  if [[ $SERVER =~ '^([a-zA-Z]+[0-9]+)([a-zA-Z]+[0-9]+[a-zA-Z])(\..*)?$' ]]; then
    PLATFORM=$match[1]
    NAME=$match[2]
    RETURN="%K{$COLOR}%F{black}${PLATFORM}%k%F{$COLOR}${NAME}%f"
    RETURN="%F{white}${PLATFORM}%k%F{$COLOR}${NAME}%f"
  elif [[ $SERVER =~ '^([a-zA-Z0-9]+)(\..*)?$' ]]; then
    NAME=$match[1]
    RETURN="%F{$COLOR}$NAME%f"
  else
    RETURN="%F{$COLOR}$SERVER%f"
  fi
  echo $RETURN
}

if autoload -Uz is-at-least && is-at-least 5.3; then
  autoload -Uz add-zle-hook-widget && \
      add-zle-hook-widget -Uz keymap-select _prompt_couloum_keymap_select
else
  zle -N zle-keymap-select _prompt_couloum_keymap_select
fi

typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1

setopt nopromptbang prompt{cr,percent,sp,subst}

# Depends on duration-info module to show last command duration
if (( ${+functions[duration-info-preexec]} && \
    ${+functions[duration-info-precmd]} )); then
  zstyle ':zim:duration-info' format ' took %B%F{yellow}%d%f%b'
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi

zstyle ':zim:prompt-pwd:fish-style' dir-length 0
zstyle ':zim:prompt-pwd:tail' length 4
zstyle ':zim:prompt-pwd' git-root no

typeset -gA git_info
if (( ${+functions[git-info]} )); then
  # Set git-info parameters.
  #zstyle ':zim:git-info' verbose yes
  #zstyle ':zim:git-info:action' format '%F{default}:%F{1}%s'
  #zstyle ':zim:git-info:ahead' format ' %F{5}⬆'
  #zstyle ':zim:git-info:behind' format ' %F{5}⬇'
  #zstyle ':zim:git-info:branch' format ' %F{2}%b'
  #zstyle ':zim:git-info:commit' format ' %F{3}%c'
  #zstyle ':zim:git-info:indexed' format ' %F{2}✚'
  #zstyle ':zim:git-info:unindexed' format ' %F{4}✱'
  #zstyle ':zim:git-info:position' format ' %F{5}%p'
  #zstyle ':zim:git-info:stashed' format ' %F{6}✭'
  #zstyle ':zim:git-info:untracked' format ' %F{default}◼'
  #zstyle ':zim:git-info:keys' format \
  #  'status' '$(coalesce "%b" "%p" "%c")%s%A%B%S%i%I%u'

  # Set git-info parameters.
  zstyle ':zim:git-info' verbose 'yes'
  zstyle ':zim:git-info:branch' format "%f%F{white}%b%f"   		# 
  zstyle ':zim:git-info:commit' format '%F{yellow}%c%f'                 # 
  zstyle ':zim:git-info:position' format '%F{white}%p%f'
  zstyle ':zim:git-info:added' format "%F{white}✚%f"        		# ✚
  zstyle ':zim:git-info:deleted' format "%F{white}✖%f"      		# ✖
  zstyle ':zim:git-info:dirty' format "%F{red}≠%D%f|"      		# ≠
  zstyle ':zim:git-info:modified' format "%F{white}●%f"     		# ●
  zstyle ':zim:git-info:untracked' format "%F{white}?%f"                # ?
  zstyle ':zim:git-info:ahead' format "%F{white}↑%A%f"      		# ↑
  zstyle ':zim:git-info:behind' format "%F{white}↓%B%f"     		# ↓
  zstyle ':zim:git-info:clean' format "%F{green}✔%f"     		# ✔
  zstyle ':zim:git-info:stashed' format "|%F{yellow}⚑%S%f"     		# ⚑
  zstyle ':zim:git-info:renamed' format "%F{white}r%f"     		# r
  zstyle ':zim:git-info:keys' format \
	'status' '%f($(coalesce "%b" "%c")%A%B|%C%D%a%m%d%r%u%S)'    # (master↑10↓3|≠10|✚●✖r?|⚑3)

  # Add hook for calling git-info before each command.
  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

SERVERNAME=$(_prompt_couloum_color_hostname)


# Define prompts.
#PS1='${SSH_TTY:+"%B%F{1}%n%f@%b%F{3}%m "}%B%F{4}$(prompt-pwd)%(!. %F{1}#.)$(_prompt_couloum_vimode)%f%b '
#RPS1='${VIRTUAL_ENV:+"%F{3}(${VIRTUAL_ENV:t})"}%(?:: %F{1}✘ %?)%B${VIM:+" %F{6}V"}${(e)git_info[status]}%f%b'
PS1='%(?..%F{red}%?✘%F{blue}|%f)%F{cyan}%T%F{blue}|${SERVERNAME}%F{green}>%F{yellow}$(prompt-pwd)%f ${git_info:+${(e)git_info[status]}}${duration_info}
%F{blue}$(_prompt_couloum_vimode)%# '
#RPS1='${git_info:+${(e)git_info[status]}}'
SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '
