!> author: 左志华
!> date: 2022-07-10
!>
!> Examples provide multiple ways of data reshaping to access the SM3 interface <br>
!> 示例提供多种访问 SM3 接口的数据重塑方式
program main

    use SM3_m, only: SM3
    use, intrinsic :: iso_c_binding, only: c_signed_char, c_size_t
    implicit none
    integer(c_signed_char) :: dgst(32)
    integer(c_signed_char) :: msg(3) ! 'abc'
    character(3) :: str = 'abc'

    print '(a)', " **** SM3 demo: "
    ! --------------------------- 字节 (bytes) ----------------------- !
    msg = [97, 98, 99]
    call SM3(msg, 3_c_size_t, dgst)
    print '(a,*(4z0.2,:,1x))', '"abc"   : ', dgst
    ! 66C7F0F4 62EEEDD9 D1F2D46B DC10E4E2 4167C487 5CF2F7A2 297DA02B 8F4BA8E0

    ! -------------------------- 十六进制 (Hex) ----------------------- !
    msg(1) = int(Z'61')
    msg(2) = int(Z'62')
    msg(3) = int(Z'63')
    call SM3(msg, 3_c_size_t, dgst)
    print '(a,*(4z0.2,:,1x))', '"abc"   : ', dgst
    ! 66C7F0F4 62EEEDD9 D1F2D46B DC10E4E2 4167C487 5CF2F7A2 297DA02B 8F4BA8E0

    ! ------------------------ 字符 (char array) --------------------- !
    msg(1) = ichar('a')
    msg(2) = ichar('b')
    msg(3) = ichar('c')
    call SM3(msg, 3_c_size_t, dgst)
    print '(a,*(4z0.2,:,1x))', '"abc"   : ', dgst
    ! 66C7F0F4 62EEEDD9 D1F2D46B DC10E4E2 4167C487 5CF2F7A2 297DA02B 8F4BA8E0

    ! ------------------ 类型重塑 (Type cast / string) ---------------- !
    msg = transfer(str, msg)
    call SM3(msg, 3_c_size_t, dgst)
    print '(a,*(4z0.2,:,1x))', '"abc"   : ', dgst
    ! 66C7F0F4 62EEEDD9 D1F2D46B DC10E4E2 4167C487 5CF2F7A2 297DA02B 8F4BA8E0

    ! ------------------------ demo2: "abcd"*4 ---------------------- !
    call SM3(transfer(repeat('abcd', 16), msg), int(4*16, c_size_t), dgst)
    print '(a,*(4z0.2,:,1x))', '"abcd"*4: ', dgst
    ! DEBE9FF9 2275B8A1 38604889 C18E5A4D 6FDB70E5 387E5765 293DCBA3 9C0C5732

end program main
