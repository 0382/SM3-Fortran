program main

    use SM3_m, only: MD5
    use, intrinsic :: iso_c_binding, only: c_signed_char, c_size_t
    implicit none
    integer(c_signed_char) :: msg(3)
    integer(c_signed_char) :: dgst(16)

    print '(a)', " **** MD5 demo: "
    msg = ichar(['a', 'b', 'c'])
    call MD5(msg, 3_c_size_t, dgst)
    print '(a,*(4z0.2,:,1x))', '"abc"   : ', dgst
    ! "abc"   : 90015098 3CD24FB0 D6963F7D 28E17F72

end program main
