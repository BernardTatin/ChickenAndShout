# _bad-r7rs.scm_, my first steps in compilation...

To use it, one of these line :

```bash
$ guile -s bad-r7rs.scm ../hexdump/hexdump.scm
$ sagittarius bad-r7rs.scm  ../hexdump/hexdump.scm
$ csi -b  -R r7rs -s bad-r7rs.scm  ../hexdump/hexdump.scm
```
On FreeBSD, we used :

 - `guile 2.0.11`,
 - `sagittarius 0.7.11`,
 - `csi (CHICKEN) 4.11.0`.

For `foment`, `mit-scheme` or `gambit-scheme`, we need some work.
