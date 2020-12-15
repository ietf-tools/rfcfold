# Noteworthy Changes in rfcfold Releases

## Upcoming Version

* More reliable reporting of folding errors.

* Adjust `sed` usage to conform to POSIX specification.  Before, only
  [GNU Sed](https://www.gnu.org/software/sed/) was known to work.
  Now the `sed` implementation included in macOS is known to work, too.

* Add a NEWS.md file to list noteworthy changes in released versions.

## Version 1.1.0 (2020-07-06)

* Removal of arbitrary upper limit for folding column.  The practical upper
  limit is determined by the available `grep` and `sed` implementations.

## Version 1.0.0 (2020-06-20)

* Initial release to [GitHub](https://github.com/ietf-tools/rfcfold)
  after publication of [RFC 8792](https://www.rfc-editor.org/info/rfc8792).

* Introduction of a version number following
  [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

* New options `-V` and `--version` to print the program version.
