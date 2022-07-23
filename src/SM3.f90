!> author: 左志华
!> date: 2022-07-09
!>
!> SM3/MD5 Hash Algorithm / GmSSL SM3 Binding <br>
!> Reference: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/1002389/files/302a3ada057c4a73830536d03e683110.pdf <br>
!> SM3/MD5 哈希算法 / GmSSL SM3/MD5 杂凑算法接口 <br>
module SM3_m

    use, intrinsic :: iso_c_binding, only: c_signed_char, c_size_t
    implicit none
    private

    public :: SM3, MD5

    interface

        !> SM3 Hash <br>
        !> SM3 杂凑算法
        !> 概述：对长度为 l (l < 2^64) 比特的消息 m，SM3 杂凑算法经过填充和迭代压缩，生成杂凑值，杂凑值长度为 256 比特 (32 字节)。
        subroutine SM3(msg, msglen, dgst) bind(c, name='sm3_digest')
            import :: c_signed_char, c_size_t
            integer(c_signed_char), intent(in) :: msg(*)    !! Message <br>
                                                            !! 输入消息
            integer(c_size_t), intent(in), value :: msglen  !! Message length <br>
                                                            !! 消息长度
            integer(c_signed_char), intent(out) :: dgst(32) !! Hash value <br>
                                                            !! 杂凑值
        end subroutine SM3

        !> MD5 Hash <br>
        !> MD5 杂凑算法
        subroutine MD5(msg, msglen, dgst) bind(c, name='md5_digest')
            import :: c_signed_char, c_size_t
            integer(c_signed_char), intent(in) :: msg(*)    !! Message <br>
                                                            !! 输入消息
            integer(c_size_t), intent(in), value :: msglen  !! Message length <br>
                                                            !! 消息长度
            integer(c_signed_char), intent(out) :: dgst(16) !! Hash value <br>
                                                            !! 杂凑值
        end subroutine MD5

    end interface

end module SM3_m
