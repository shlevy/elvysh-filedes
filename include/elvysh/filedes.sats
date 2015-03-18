staload "elvysh/errno.sats"

(* A view representing an open file descriptor.
 *
 * Indexed by the integer descriptor handle.
 *
 * In the future, may be indexed by properties such as "is readable" or similar
 *)
absview filedes ( int )

(* Close a file descriptor *)
fn close { fd: nat } ( ev: !errno_v ( free ) >> neg1_errno ( res )
                     , fdprf: filedes fd
                     | fd: int fd 
                     ): #[ res: int ] int res = "ext#"

%{#
#include <unistd.h>
%}
