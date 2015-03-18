elvysh-filedes
==============

Functions and views for safe handling of UNIX file descriptors.

The `filedes` view is used to represent an open file descriptor. It is indexed
by the integer file descriptor number. As such, it is usually passed along with
the corresponding int.

See [elvysh-main][1] for the recommended way to obtain initial `filedes` views
for stdio.

Future work
-----------

Ideally some way to model properties like "this file descriptor is readable"
will be added.

More functions for handling files will be added as needed.

Part of the [elvysh][2] project.

[1]: https://github.com/shlevy/elvysh-main
[2]: https://github.com/shlevy/elvysh-project-documentation
