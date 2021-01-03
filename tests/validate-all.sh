#!/bin/bash

run_cmd() {
  # $1 is the cmd to run
  # $2 is the expected error code

  output=`$1 2>&1`
  exit_code=$?
  if [[ $exit_code -ne $2 ]]; then
    printf "failed.\n"
    printf "  - exit code: %d (expected %d)\n" "$exit_code" "$2"
    printf "  - command: %s\n" "$1"
    printf "  - output: %s\n\n" "$output"
    exit
  fi
}

test_file() {
  # $1 : strategy: 1, 2  (0 for auto)
  # $2 : is the file to test
  # $3 : expected folding exit code
  # $4 : expected unfolding exit code
  # $5 : null or maxcol for folding

  printf "testing $2..."

  if [ -z "$5" ]; then
    command="../rfcfold -s $1 -d -i $2 -o $2.folded"
  else
    command="../rfcfold -s $1 -d -c $5 -i $2 -o $2.folded"
  fi
  expected_exit_code=$3
  run_cmd "$command" $expected_exit_code
  if [ $expected_exit_code -ne 0 ]; then
    printf "okay.\n"
    if [ $expected_exit_code -eq 255 ]; then
      rm $2.folded*
    fi
    return
  fi

  command="../rfcfold -d -r -i $2.folded -o $2.folded.unfolded"
  expected_exit_code=$4
  run_cmd "$command" $expected_exit_code

  command="diff -q $2 $2.folded.unfolded"
  expected_exit_code=0
  run_cmd "$command" $expected_exit_code

  printf "okay.\n"
  rm $2.folded*
}

test_unfoldable_file() {
  # $1 : strategy: 1, 2  (0 for auto)
  # $2 : is the file to test
  # $3 : expected error code

  printf "testing $2..."

  command="../rfcfold -d -r -i $2 -o $2.unfolded"
  expected_exit_code=$3
  run_cmd "$command" $expected_exit_code

  printf "okay.\n"
  if [[ $3 -eq 255 ]]; then
    rm $2.unfolded
  fi
}

test_prefolded_file() {
  # $1 : strategy: 1, 2  (0 for auto)
  # $2 : is the file to test
  # $3 : is the original file (which the unfolding should match)

  printf "testing $2..."

  command="../rfcfold -d -r -i $2 -o $2.unfolded"
  expected_exit_code=0
  run_cmd "$command" $expected_exit_code

  command="diff -q $3 $2.unfolded"
  expected_exit_code=0
  run_cmd "$command" $expected_exit_code

  printf "okay.\n"
  rm $2.unfolded
}

failed_test() {
  echo 'failed.'
  exit 1
}

test_folding_emits_warning() {
  # $1 : is the file to test
  # $2 : is the extended regular expression to check
  printf -- 'testing that folding %s emits a warning...' "$1"
  if ../rfcfold -i "$1" -o "$1.folded" 2>&1 | grep -Eq "$2"; then
    rm "$1.folded"
    echo okay.
  else
    rm -f "$1.folded"
    failed_test
  fi
}

have_gnu_grep_sed() {
  local GREP SED
  type ggrep > /dev/null 2>&1 && GREP=ggrep || GREP=grep
  type gsed > /dev/null 2>&1 && SED=gsed || SED=sed
  "$GREP" --version | grep -q GNU && "$SED" --version | grep -q GNU && return 0
  return 1
}


main() {
  printf 'starting tests for -h/--help options...'
  ../rfcfold -h 2>/dev/null | grep -Fq 'Usage:' || failed_test
  ../rfcfold --help 2>/dev/null | grep -Fq 'Usage:' || failed_test
  echo 'okay.'
  printf 'starting tests for -V/--version options...'
  ../rfcfold -V | grep -Eq 'version +[0-9]+\.[0-9]+\.[0-9]+' || failed_test
  ../rfcfold --version | grep -Eq 'version +[0-9]+\.[0-9]+\.[0-9]+' || failed_test
  echo 'okay.'
  echo
  echo "starting neither tests..."
  test_file 1 neither-can-fold-it-1.txt 1
  test_file 2 neither-can-fold-it-1.txt 1
  test_file 1 neither-can-fold-it-2.txt 1
  test_file 2 neither-can-fold-it-2.txt 1
  test_file 1 neither-can-fold-it-3.txt 1
  test_file 2 neither-can-fold-it-3.txt 1
  echo
  echo "starting unfoldable tests..."
  test_unfoldable_file 1 neither-can-unfold-it-1.txt 255
  test_unfoldable_file 2 neither-can-unfold-it-1.txt 255
  test_unfoldable_file 1 neither-can-unfold-it-2.txt 1
  test_unfoldable_file 2 neither-can-unfold-it-2.txt 1
  test_unfoldable_file 1 neither-can-unfold-it-3.txt 1
  test_unfoldable_file 2 neither-can-unfold-it-3.txt 1
  echo
  echo "starting unfolding smart tests..."
  test_prefolded_file 1 example-3.1.txt.folded.smart example-3.txt
  test_prefolded_file 2 example-3.2.txt.folded.smart example-3.txt
  echo
  echo "starting old unfolding forced tests..."
  test_prefolded_file 1 neither-can-fold-it-1.force-folded.1.txt neither-can-fold-it-1.txt
  test_prefolded_file 2 neither-can-fold-it-1.force-folded.2.txt neither-can-fold-it-1.txt
  test_prefolded_file 1 neither-can-fold-it-2.force-folded.1.txt neither-can-fold-it-2.txt
  test_prefolded_file 2 neither-can-fold-it-2.force-folded.2.txt neither-can-fold-it-2.txt
  echo
  echo "starting new unfolding forced tests..."
  test_prefolded_file 1 example-4.1.txt.folded.forced example-4.txt
  test_prefolded_file 2 example-4.2.txt.folded.forced example-4.txt
  echo
  echo "starting only-2 tests..."
  test_file 1 only-2-can-fold-it-1.txt 1
  test_file 2 only-2-can-fold-it-1.txt 0   0
  test_file 1 only-2-can-fold-it-2.txt 1
  test_file 2 only-2-can-fold-it-2.txt 0   0
  test_file 1 only-2-can-fold-it-3.txt 1
  test_file 2 only-2-can-fold-it-3.txt 0   0
  test_file 1 only-2-can-fold-it-4.txt 1
  test_file 2 only-2-can-fold-it-4.txt 0   0
  test_file 1 only-2-can-fold-it-5.txt 1
  test_file 2 only-2-can-fold-it-5.txt 0   0
  test_file 1 only-2-can-fold-it-6.txt 1
  test_file 2 only-2-can-fold-it-6.txt 0   0
  test_file 1 spaces-1.txt             1
  test_file 2 spaces-1.txt             0   0
  test_file 1 spaces-2.txt             1
  test_file 2 spaces-2.txt             0   0
  test_file 1 spaces-3.txt             1
  test_file 2 spaces-3.txt             0   0
  echo
  echo "starting strategy #1 tests..."
  test_file 1 contains-tab.txt         1
  test_file 1 already-exists.txt       1
  test_file 1 folding-needed.txt       0   0
  test_file 1 nofold-needed.txt      255 255
  test_file 1 nofold-needed.txt        1   x  67
  test_file 1 nofold-needed-again.txt  0   0  67
  echo
  echo "starting strategy #2 tests..."
  test_file 2 contains-tab.txt         1
  test_file 2 already-exists.txt       1
  test_file 2 folding-needed.txt       0   0
  test_file 2 nofold-needed.txt      255 255
  test_file 2 nofold-needed.txt        1   x  67
  test_file 2 nofold-needed-again.txt  0   0  67
  echo
  echo "starting minimum folding column tests..."
  test_file 1 example-1.txt            1   x  43
  test_file 1 example-1.txt            0   0  44
  test_file 2 example-1.txt            1   x  44
  test_file 2 example-1.txt            0   0  45
  echo
  # A folding column limit is imposed by the regular expression implementation
  # used by the system.  The given folding column + 1 must be less than the
  # system limit for a regular expression repeat cound inside \{\}.
  echo "starting folding column limit tests..."
  test_file 1 spaces-1.txt           255 255  70
  test_file 2 spaces-1.txt           255 255  70
  test_file 1 spaces-2.txt           255 255 140
  test_file 2 spaces-2.txt           255 255 140
  test_file 1 example-2.txt            0   0 148
  test_file 1 example-2.txt            0   0 149
  test_file 2 example-2.txt            0   0 148
  test_file 2 example-2.txt            0   0 149
  test_file 1 spaces-3.txt           255 255 210
  test_file 2 spaces-3.txt           255 255 210
  test_file 1 example-2.txt            0   0 254
  test_file 2 example-2.txt            0   0 254
  # 2^24=16777216 is higher than all observed repeat count limits so far:
  # - macOS and FreeBSD have a documented limit of 255 --> -c <=   254
  # - Go imposes a limit of 1000                       --> -c <=   999
  # - GNU imposes a limit of 32767                     --> -c <= 32766
  # - PCRE imposes a limit of 65535                    --> -c <= 65534
  test_file 1 example-2.txt            1   x 16777216
  if have_gnu_grep_sed; then
    test_file 1 example-2.txt            0   0 279
    test_file 2 example-2.txt            0   0 279
    test_file 1 example-2.txt          255 255 280
    test_file 2 example-2.txt          255 255 280
  else
    echo "skipping tests with folding columns 279 and 280."
  fi
  echo
  echo "starting warning tests..."
  test_folding_emits_warning contains-formfeed.txt 'Warning:.*ASCII control'
  test_folding_emits_warning contains-del.txt 'Warning:.*ASCII control'
  test_folding_emits_warning contains-utf8.txt 'Warning:.*non-ASCII'
  test_folding_emits_warning empty-file 'Warning:.*is empty'
  echo
  printf "testing unfolding of smart folding examples 3.1 and 3.2..."
  expected_exit_code=0
  command="../rfcfold -r -i example-3.1.txt.folded.smart -o example-3.1.txt.folded.smart.unfolded"
  run_cmd "$command" $expected_exit_code
  command="../rfcfold -r -i example-3.2.txt.folded.smart -o example-3.2.txt.folded.smart.unfolded"
  run_cmd "$command" $expected_exit_code
  command="diff -q example-3.1.txt.folded.smart.unfolded example-3.2.txt.folded.smart.unfolded"
  run_cmd "$command" $expected_exit_code
  rm example-3.1.txt.folded.smart.unfolded example-3.2.txt.folded.smart.unfolded
  echo "okay."
  echo
  echo "verifying that rfcfold itself needs no folding..."
  test_file 0 ../rfcfold             255
  echo
  echo "all tests passed (or skipped)."
}

main "$@"

