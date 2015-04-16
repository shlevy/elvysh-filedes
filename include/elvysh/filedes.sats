staload "elvysh/errno.sats"

(* Represents whether a file descriptor is readable *)
datasort readable_property =
  | is_readable
  | not_readable

(* A view representing an open file descriptor.
 *
 * Indexed by the integer descriptor handle and whether it is readable.
 *)
absview filedes ( int, readable_property )

(* A file descriptor with any properties *)
viewdef any_filedes ( i: int ) = [ p: readable_property ] filedes ( i, p )

(* Close a file descriptor *)
fn close { fd: nat } ( ev: !errno_v ( free ) >> neg1_errno ( res )
                     , fdprf: any_filedes ( fd )
                     | fd: int ( fd )
                     ): #[ res: int ] int ( res ) = "ext#"

(* A readable file descriptor *)
viewdef readable_filedes ( i: int ) = filedes ( i, is_readable )

(* A view representing an array that is partially initialized.
 *
 * Indexed by the type, the number of initialized elements (AKA the fill), the
 * total number of elements, and the address of the array.
 *
 * ctors:
 * partially_initialized_array: Constructed from two contiguous arrays starting
 * at 'buf' and spanning enough memory for 'total' values of type 't', where
 * the first contains 'fill' initialized values and the second's values may be
 * uninitialized
 *)
dataview partially_initialized_array ( t: t@ype
                                     , int (* fill *)
                                     , int (* total *)
                                     , addr
                                     ) =
  | { fill, total: nat | fill <= total } { buf : addr }
      partially_initialized_array ( t, fill, total, buf ) of
        ( @[ t ][ fill ] @ buf
        , @[ t? ][ total - fill ] @ ( buf + fill * sizeof(t) )
        )

(* Read from a file descriptor
 *
 * Reads up to 'total' bytes into 'buf' from 'fd'.
 *
 * Returns the number of bytes read into 'buf', or -1 on error.
 *)
fn read { fd: nat } { buf: addr } { fill, total: nat | fill <= total }
  ( ev: !errno_v ( free ) >> neg1_errno ( res )
  , fdprf: !readable_filedes ( fd )
  , !partially_initialized_array_v ( byte, fill, total, buf ) >>
      partially_initialized_array_v ( byte, max ( fill, res ), total, buf )
  | fd: int ( fd )
  , buf: ptr buf
  , total: size_t total
  ): #[ res: int ] ssize_t ( res ) = "ext#"

%{#
#include <unistd.h>
%}
