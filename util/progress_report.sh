#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function lint_progress_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local REPO_DIR="$(readlink -m -- "$BASH_SOURCE"/../..)"
  # cd -- "$REPO_DIR" || return $?
  local TOP_HEAD="$(git rev-parse HEAD)"
  [ -n "$TOP_HEAD" ] || return 4$(echo E: "Cannot detect TOP_HEAD" >&2)
  exec </dev/null
  ulimit -v $(( 1024 * 1024 ))

  cd -- lint_progress.@ || return $?
  local CWD_ABS="$(readlink -m -- .)"

  local PROGRESS_REPORT_DEST='tmp.lint_progress.txt'
  local LINT_MSGS_BFN='tmp.lint_msgs'

  case "$1" in
    --dlint ) lint_report_diffable; return $?;;
  esac

  export GIT_{AUTHOR,COMMITTER}_NAME='Lint progress report'
  export GIT_{AUTHOR,COMMITTER}_EMAIL='report@lint.invalid'

  local WORK_BRANCH='tmp.lint_progress'
  local FROM_BRANCH="$WORK_BRANCH".start
  git checkout "$WORK_BRANCH" || return $?
  git reset --hard "$FROM_BRANCH" || return $?
  git clean --force || return $?

  exec 6>"$PROGRESS_REPORT_DEST" || return $?
  echo $'\xEF\xBB\xBF' >&6

  local NTH_COMMIT=0
  >"$LINT_MSGS_BFN".crnt || return $?
  update_lint_report_files || return $?

  local COMMITS=()
  readarray -t COMMITS < <(
    git log --reverse --pretty=format:%h:%at:%s "HEAD..$TOP_HEAD")

  local C_HASH= C_UTS= C_SUBJ=
  local N_ADD= N_DEL=
  for C_SUBJ in "${COMMITS[@]}"; do
    [ -n "$C_SUBJ" ] || continue
    C_HASH="${C_SUBJ%%:*}"; C_SUBJ="${C_SUBJ#*:}"
    C_UTS="${C_SUBJ%%:*}"; C_SUBJ="${C_SUBJ#*:}"
    (( NTH_COMMIT += 1 ))

    git reset --hard "$C_HASH" || return $?
    update_lint_report_files || return $?

    BUF="$(printf -- '%(%F %T)T' "$C_UTS") ($C_HASH"
    [ "$N_ADD" == 0 ] || BUF+=" ⚠ $N_ADD"
    [ "$N_DEL" == 0 ] || BUF+=" √ $N_DEL"
    BUF+=") $C_SUBJ"
    echo "$BUF"
    echo "$BUF" >&6
    cat -- "$LINT_MSGS_BFN".add >&6
    cat -- "$LINT_MSGS_BFN".del >&6
    echo >&6

    ( head --lines=2 -- "$LINT_MSGS_BFN".del
      [ "$NTH_COMMIT" == 1 ] || head --lines=2 -- "$LINT_MSGS_BFN".add
    ) | sed -re 's~^~    ~'
    [ "$N_DEL:$N_ADD" == 0:0 ] || echo
  done

  exec 6<&-
  git reset --hard "$FROM_BRANCH" || return $?
}


function lint_report_diffable () {
  exec < <(eslint . | LANG=C sed -rf <(echo '
    / [0-9]+ errors? and [0-9]+ warnings? potentially fixable with the /d
    /^ *[^A-Za-z0-9 ]+ [0-9]+ problems \(/d
    /^$/d
    ') | LANG=C sed -rf <(echo '
    s~^\s+([0-9]+|$ line ):([0-9]+|$ column )\s+($\
      |\S+\s+|$ severity )~<!>\n~
    /\n/{
      s~\s+(\S+)$~\n\1~
      s~\n([^\n]*)\n(\S+)$~[\2] \1~
      s~( [oi]n line )[0-9]+\b~\1…~g
      s~( This line has a length of )[0-9]+\b~\1…~
      s~( Missing file extension "\S+" for )"\S+"~\1…~
    }
    ') )
  local LN= FILE=
  while IFS= read -r LN; do
    LN="${LN//"$CWD_ABS"/'/…cwd…'}"
    case "$LN" in
      '' ) continue;;
      '/'* )
        FILE="$LN"
        FILE="${FILE#/…cwd…/}"
        continue;;
      '<!>'* ) LN="$FILE ${LN#*>}";;
    esac
    echo "$LN"
  done |
    LANG=C "$REPO_DIR"/util/censor_user_paths.sed |
    sort --version-sort
}


function update_lint_report_files () {
  mv --no-target-directory \
    -- "$LINT_MSGS_BFN".crnt "$LINT_MSGS_BFN".prev || return $?
  lint_report_diffable >"$LINT_MSGS_BFN".crnt || return $?
  ( [ "$NTH_COMMIT" == 0 ] || diff -U 9009009 -- "$LINT_MSGS_BFN".{prev,crnt}
  ) | sed -nre '1b;2b;/^[+-]/p' >"$LINT_MSGS_BFN".diff
  N_ADD="$(listify_lint_report_file + add '⚠' )"
  N_DEL="$(listify_lint_report_file - del '√' )"
}


function listify_lint_report_file () {
  local DIFF_SIGN="$1"; shift
  local FEXT="$1"; shift
  local BULLET="$1"; shift
  local SED='s~^\'"$DIFF_SIGN~$BULLET ~p"
  sed -nre "$SED" -- "$LINT_MSGS_BFN".diff |
    tee -- "$LINT_MSGS_BFN.$FEXT".ln | wc --lines | tr -cd 0-9
  SED='s~^\s+1\s( *\S+)~\1~; s~^\s+([0-9]+)\s( *\S+)~\2×\1~'
  <"$LINT_MSGS_BFN.$FEXT".ln sort --version-sort | uniq --count |
    LANG=C sed -re "$SED" >"$LINT_MSGS_BFN.$FEXT"
  rm -- "$LINT_MSGS_BFN.$FEXT".ln
}










lint_progress_cli_init "$@"; exit $?
