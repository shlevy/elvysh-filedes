staload "elvysh/errno.sats"
staload "elvysh/partially-initialized-array.sats"

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

(* Read from a file descriptor
 *
 * Reads up to 'total' bytes into 'buf' from 'fd'.
 *
 * Returns the number of bytes read into 'buf', or -1 on error.
 *)
fn read { fd: nat } { buf: addr } { fill, total: nat | fill <= total }
  ( ev: !errno_v ( free ) >> neg1_errno ( res )
  , fdprf: !readable_filedes ( fd )
  , !partially_initialized_array ( byte, fill, total, buf ) >>
      partially_initialized_array ( byte, max ( fill, res ), total, buf )
  | fd: int ( fd )
  , buf: ptr buf
  , total: size_t total
  ): #[ res: int ] ssize_t ( res ) = "ext#"

%{#
#include <unistd.h>
%}
