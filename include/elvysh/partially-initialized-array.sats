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

(* Collapse the fill of a partially initialized array whose fill is the maximum
 * of two values to the old value.
 *
 * Some functions (such as the POSIX read) may fill a partially initialized
 * array with a dynamically determined number of values. In that case, the total
 * number of initialized values is the maximum of the number of initialized
 * values present before the call and the number filled by the function itself,
 * since the functions won't uninitialize old values. Often, though, we only
 * care about accessing as many values as were initialized originally, even if
 * more were initialized by the function. This view-changing function can be
 * used in that case to collapse the max into the original value.
 *)
prfun partially_initialized_array_unmax_before
  { t: t@ype } { before
               , after
               , total: nat
               | before <= total && after <= total
               } { buf : addr }
    ( pf: partially_initialized_array ( t
                                      , max ( before, after )
                                      , total
                                      , buf
                                      ) ):<prf>
      partially_initialized_array ( t, before, total, buf )

(* Collapse the fill of a partially initialized array whose fill is the maximum
 * of two values to the new value.
 *
 * Some functions (such as the POSIX read) may fill a partially initialized
 * array with a dynamically determined number of values. In that case, the total
 * number of initialized values is the maximum of the number of initialized
 * values present before the call and the number filled by the function itself,
 * since the functions won't uninitialize old values. Often, though, we only
 * care about accessing as many values as were initialized by the function, even
 * if more were initialized originally. This view-changing function can be used
 * in that case to collapse the max into the new value.
 *)
prfun partially_initialized_array_unmax_after
  { t: t@ype } { before
               , after
               , total: nat
               | before <= total && after <= total
               } { buf : addr }
    ( pf: partially_initialized_array ( t
                                      , max ( before, after )
                                      , total
                                      , buf
                                      ) ):<prf>
      partially_initialized_array ( t, after, total, buf )
