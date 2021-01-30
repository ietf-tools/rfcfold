# rfcfold

`rfcfold` is a [Bash](https://www.gnu.org/software/bash/)
script that folds or unfolds a text file according to
[RFC 8792](https://www.rfc-editor.org/info/rfc8792),
*Handling Long Lines in Content of Internet-Drafts and RFCs*.
The (un)folding operations are implemented with `grep` and `sed`.

## rfcfold Usage

Invoking `rfcfold` with the `-h` option shows usage information:

```
Folds or unfolds the input text file according to RFC 8792.

Usage: rfcfold [-h] [-V] [-d] [-q] [-s <strategy>] [-c <col>] [-r] -i <infile> -o <outfile>

  -s: strategy to use, '1' or '2' (default: try 1, else 2)
  -c: column to fold on (default: 69)
  -r: reverses the operation
  -i: the input filename
  -o: the output filename
  -d: show debug messages (unless -q is given)
  -q: quiet (suppress error and debug messages)
  -h: show this message
  -V: print version information

Exit status code: 1 on error, 0 on success, 255 on no-op.
```

### Examples

1. Fold the file `original.txt` and write the result to `folded.txt`:

    `rfcfold -i original.txt -o folded.txt`

2. Unfold the file `folded.txt` and write the result to `unfolded.txt`:

    `rfcfold -r -i folded.txt -o unfolded.txt`

## Limitations

`rfcfold` has some limitations, because its primary intended use is for
text file inclusions in IETF RFC and Internet-Draft (I-D) documents, and
because it is implemented as a Bash script relying on `grep` and `sed`.

### TAB is Prohibited

The primary application of `rfcfold` lies in creating text files that
can be included in IETF RFC and I-D documents by ensuring a maximum line
length (in characters).  Thus the input file is not allowed to contain
TAB characters, because they are not allowed for text fragments in an RFC.

### ASCII Control and Non-ASCII is Unsupported

Most ASCII control characters and non-ASCII characters are problematic
in the context of IETF RFC and I-D documents, and `rfcfold` emits a
warning if it finds them in the input data.  IETF RFC and I-D documents
allow limited use of UTF-8 encoded Unicode characters, but `rfcfold`
does not take Unicode specifics into account.

### Unicode is Unsupported

Depending on the operating system respectively the available `grep` and
`sed` implementations, `rfcfold` may be able to process Unicode text
files, but with limitations.  The display width of Unicode characters is
not taken into consideration when folding.  Every character is assumed
to have single width.  Since printable Unicode characters can be wider
than single width, and some implementations even display some single
width characters with more than single width, the end result may not
look as expected.  There are additional complications with Unicode, e.g.,
combining characters, none of which are taken into account by `rfcfold`.
As such Unicode is not *supported* by `rfcfold`.

## grep and sed

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

Use of both GNU grep and GNU sed may increase the maximum usable value
for the folding column over using system-provided grep and sed.
