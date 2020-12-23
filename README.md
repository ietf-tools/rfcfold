# rfcfold

`rfcfold` is a [Bash](https://www.gnu.org/software/bash/)
script that folds or unfolds a text file according to
[RFC 8792](https://www.rfc-editor.org/info/rfc8792),
*Handling Long Lines in Content of Internet-Drafts and RFCs*.
The (un)folding operations are implemented with `grep` and `sed`.

## Usage

Invoking `rfcfold` with the `-h` option shows usage information.

## `grep` and `sed`

Usage of both
[grep](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/grep.html)
and
[sed](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/sed.html)
conforms to the
[POSIX](https://pubs.opengroup.org/onlinepubs/9699919799/)
specification.

On non-[GNU](https://www.gnu.org/) systems, GNU tools are often
installed to complement the system-provided ones.  On such systems,
[GNU grep](https://www.gnu.org/software/grep/)
and
[GNU sed](https://www.gnu.org/software/sed/)
are used if they are available as `ggrep` and `gsed`.
