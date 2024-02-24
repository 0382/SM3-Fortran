program main

    use SM3_module
    use, intrinsic :: iso_c_binding, only: c_int8_t, c_size_t
    implicit none
    integer(c_int8_t) :: msg(3)
    integer(c_int8_t) :: dgst(MD5_DIGEST_SIZE)
    type(MD5_CTX) :: ctx

    print '(a)', " **** MD5 demo: "
    msg = ichar(['a', 'b', 'c'])
    call md5_digest(msg, 3_c_size_t, dgst)
    print '(a,*(4z0.2,:,1x))', '"abc"   : ', dgst
    ! "abc"   : 90015098 3CD24FB0 D6963F7D 28E17F72

    call md5_init(ctx)
    call md5_update(ctx, msg(1:2), 2_c_size_t)
    call md5_update(ctx, msg(3:3), 1_c_size_t)
    call md5_finish(ctx, dgst)
    print '(a,*(4z0.2,:,1x))', '"abc"   : ', dgst
end program main
