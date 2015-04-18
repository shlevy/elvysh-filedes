elvysh-filedes
==============

Functions and views for safe handling of UNIX file descriptors.

The `filedes` view is used to represent an open file descriptor. It is indexed
by the integer file descriptor number, as well as any properties it might have
such as whether or not it is readable. It is usually passed along with the
corresponding dynamic int when used in functions.

See [elvysh-main][1] for the recommended way to obtain initial `filedes` views
for stdio.

Partially initialized arrays
-----------------------------

This library also defines the `partially_initialized_array` view, which can be
used to represent a buffer that has been partially initialized and may be
further initialized by a function like `read`.

Future work
-----------

More functions for handling files will be added as needed.


Part of the [elvysh][2] project.

[1]: https://github.com/shlevy/elvysh-main
[2]: https://github.com/shlevy/elvysh-project-documentation
