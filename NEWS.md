# Noteworthy Changes in rfcfold Releases

## Version 1.3.0 (2021-01-30)

* Support file names starting with a hyphen ('-').

* Add *forced folding* to both folding strategies.

* Support using a *non-regular* file, e.g., a pipe, as input file.
  This allows the use of `rfcfold` as any part of a pipeline by using
  `/dev/stdin` as input filename and `/dev/stdout` as output filename.
  Both `/dev/stdin` and `/dev/stdout` are provided by Bash if the
  operating system does not provide them itself.

* Use a POSIX compatible method to detect ASCII control or non-ASCII characters
  in an input file for folding.

* Prefer [GNU grep](https://www.gnu.org/software/grep/) installed as `ggrep`
  over the grep included in the operating system, if available.  On some
  systems, e.g. macOS, this may increase the maximum folding column value for
  `rfcfold`, if combined with using GNU sed (e.g, as `gsed`).

## Version 1.2.1 (2020-12-15)

* Update NEWS.md file with current information.

## Version 1.2.0 (2020-12-15)

* More reliable reporting of folding errors.

* Adjust `sed` usage to conform to POSIX specification.  Before, only
  [GNU Sed](https://www.gnu.org/software/sed/) was known to work.
  Now the `sed` implementation included in macOS is known to work, too.

* Add a NEWS.md file to list noteworthy changes in released versions.

## Version 1.1.0 (2020-07-06)

* Removal of arbitrary upper limit for folding column.  The practical upper
  limit is determined by the available `grep` and `sed` implementations.

## Version 1.0.1 (2020-06-27)

* Improve portability by replacing problematic use of `echo` with `printf`.
  This makes `rfcfold` compatible with the Z shell (`zsh`).

## Version 1.0.0 (2020-06-20)

* Initial release to [GitHub](https://github.com/ietf-tools/rfcfold)
  after publication of [RFC 8792](https://www.rfc-editor.org/info/rfc8792).

* Introduction of a version number following
  [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

* New options `-V` and `--version` to print the program version.
