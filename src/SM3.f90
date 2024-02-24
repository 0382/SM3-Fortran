!> author: 左志华
!> date: 2022-07-09
!>
!> SM3/MD5 Hash Algorithm / GmSSL SM3 Binding <br>
!> Reference: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/1002389/files/302a3ada057c4a73830536d03e683110.pdf <br>
!> SM3/MD5 哈希算法 / GmSSL SM3/MD5 杂凑算法接口 <br>
module SM3_module

    use, intrinsic :: iso_c_binding, only: c_signed_char, c_size_t, c_int32_t, c_int64_t, c_int8_t
    implicit none

    private
    public :: MD5_CTX, MD5_DIGEST_SIZE, MD5_BLOCK_SIZE, MD5_STATE_WORDS
    public :: md5_digest, md5_init, md5_update, md5_finish
    public :: SM3_DIGEST_SIZE, SM3_BLOCK_SIZE, SM3_STATE_WORDS, SM3_HMAC_SIZE
    public :: SM3_CTX, SM3_HMAC_CTX, SM3_KDF_CTX
    public :: sm3_digest, sm3_init, sm3_update, sm3_finish
    public :: sm3_hmac, sm3_hmac_init, sm3_hmac_update, sm3_hmac_finish
    public :: sm3_kdf_init, sm3_kdf_update, sm3_kdf_finish
    public :: hex_to_bytes

    integer, parameter :: MD5_DIGEST_SIZE = 16
    integer, parameter :: MD5_BLOCK_SIZE = 64
    integer, parameter :: MD5_STATE_WORDS = MD5_BLOCK_SIZE/c_int32_t

    integer, parameter :: SM3_DIGEST_SIZE = 32
    integer, parameter :: SM3_BLOCK_SIZE = 64
    integer, parameter :: SM3_STATE_WORDS = 8
    integer, parameter :: SM3_HMAC_SIZE = SM3_DIGEST_SIZE

    type, bind(c) :: MD5_CTX
        integer(c_int32_t) :: state(MD5_STATE_WORDS)
        integer(c_int64_t) :: nblocks
        integer(c_int8_t) :: block(MD5_BLOCK_SIZE)
        integer(c_size_t) :: num
    end type MD5_CTX

    type, bind(c) :: SM3_CTX
        integer(c_int32_t) :: digest(SM3_STATE_WORDS)
        integer(c_int64_t) :: nblocks
        integer(c_int8_t) :: block(SM3_BLOCK_SIZE)
        integer(c_size_t) :: num
    end type SM3_CTX

    type, bind(c) :: SM3_HMAC_CTX
        type(SM3_CTX) :: sm3_ctx
        integer(c_int8_t) :: key(SM3_BLOCK_SIZE)
    end type SM3_HMAC_CTX

    type, bind(c) :: SM3_KDF_CTX
        type(SM3_CTX) :: sm3_ctx
        integer(c_size_t) :: outlen
    end type SM3_KDF_CTX

    interface

        subroutine sm3_init(ctx) bind(c, name='sm3_init')
            import :: SM3_CTX
            type(SM3_CTX), intent(inout) :: ctx
        end subroutine sm3_init

        subroutine sm3_update(ctx, data, datalen) bind(c, name='sm3_update')
            import :: SM3_CTX, c_int8_t, c_size_t
            type(SM3_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(in) :: data(*)
            integer(c_size_t), intent(in), value :: datalen
        end subroutine sm3_update

        subroutine sm3_finish(ctx, dgst) bind(c, name='sm3_finish')
            import :: SM3_CTX, c_int8_t, SM3_DIGEST_SIZE
            type(SM3_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(out) :: dgst(SM3_DIGEST_SIZE)
        end subroutine sm3_finish

        !> SM3 Hash <br>
        !> SM3 杂凑算法
        !> 概述：对长度为 l (l < 2^64) 比特的消息 m，SM3 杂凑算法经过填充和迭代压缩，生成杂凑值，杂凑值长度为 256 比特 (32 字节)。
        subroutine sm3_digest(msg, msglen, dgst) bind(c, name='sm3_digest')
            import :: c_int8_t, c_size_t, SM3_DIGEST_SIZE
            integer(c_int8_t), intent(in) :: msg(*)                 !! Message <br>
                                                                    !! 输入消息
            integer(c_size_t), intent(in), value :: msglen          !! Message length <br>
                                                                    !! 消息长度
            integer(c_int8_t), intent(out) :: dgst(SM3_DIGEST_SIZE) !! Hash value <br>
                                                                    !! 杂凑值
        end subroutine sm3_digest

        subroutine sm3_hmac_init(ctx, key, keylen) bind(c, name='sm3_hmac_init')
            import :: SM3_HMAC_CTX, c_int8_t, c_size_t
            type(SM3_HMAC_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(in) :: key(*)
            integer(c_size_t), intent(in), value :: keylen
        end subroutine sm3_hmac_init

        subroutine sm3_hmac_update(ctx, data, datalen) bind(c, name='sm3_hmac_update')
            import :: SM3_HMAC_CTX, c_int8_t, c_size_t
            type(SM3_HMAC_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(in) :: data(*)
            integer(c_size_t), intent(in), value :: datalen
        end subroutine sm3_hmac_update

        subroutine sm3_hmac_finish(ctx, mac) bind(c, name='sm3_hmac_finish')
            import :: SM3_HMAC_CTX, c_int8_t, SM3_HMAC_SIZE
            type(SM3_HMAC_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(out) :: mac(SM3_HMAC_SIZE)
        end subroutine sm3_hmac_finish

        subroutine sm3_hmac(key, keylen, data, datalen, mac) bind(c, name='sm3_hmac')
            import :: c_int8_t, c_size_t, SM3_HMAC_SIZE
            import :: SM3_HMAC_CTX
            integer(c_int8_t), intent(in) :: key(*)              !! Key <br>
                                                                 !! 密钥
            integer(c_size_t), intent(in), value :: keylen       !! Key length <br>
                                                                 !! 密钥长度
            integer(c_int8_t), intent(in) :: data(*)             !! Message <br>
                                                                 !! 输入消息
            integer(c_size_t), intent(in), value :: datalen      !! Message length <br>
                                                                 !! 消息长度
            integer(c_int8_t), intent(out) :: mac(SM3_HMAC_SIZE) !! MAC <br>
                                                                 !! 消息认证码
        end subroutine sm3_hmac

        subroutine sm3_kdf_init(ctx, outlen) bind(c, name='sm3_kdf_init')
            import :: SM3_KDF_CTX, c_size_t
            type(SM3_KDF_CTX), intent(inout) :: ctx
            integer(c_size_t), intent(in), value :: outlen
        end subroutine sm3_kdf_init

        subroutine sm3_kdf_update(ctx, data, datalen) bind(c, name='sm3_kdf_update')
            import :: SM3_KDF_CTX, c_int8_t, c_size_t
            type(SM3_KDF_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(in) :: data(*)
            integer(c_size_t), intent(in), value :: datalen
        end subroutine sm3_kdf_update

        subroutine sm3_kdf_finish(ctx, out) bind(c, name='sm3_kdf_finish')
            import :: SM3_KDF_CTX, c_int8_t
            type(SM3_KDF_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(out) :: out(*)
        end subroutine sm3_kdf_finish

        subroutine md5_init(ctx) bind(c, name='md5_init')
            import :: MD5_CTX
            type(MD5_CTX), intent(inout) :: ctx
        end subroutine md5_init

        subroutine md5_update(ctx, data, datalen) bind(c, name='md5_update')
            import :: MD5_CTX, c_int8_t, c_size_t
            type(MD5_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(in) :: data(*)
            integer(c_size_t), intent(in), value :: datalen
        end subroutine md5_update

        subroutine md5_finish(ctx, dgst) bind(c, name='md5_finish')
            import :: MD5_CTX, c_int8_t, MD5_DIGEST_SIZE
            type(MD5_CTX), intent(inout) :: ctx
            integer(c_int8_t), intent(out) :: dgst(MD5_DIGEST_SIZE)
        end subroutine md5_finish

        !> MD5 Hash <br>
        !> MD5 杂凑算法
        subroutine md5_digest(msg, msglen, dgst) bind(c, name='md5_digest')
            import :: c_int8_t, c_size_t, MD5_DIGEST_SIZE
            integer(c_int8_t), intent(in) :: msg(*)                 !! Message <br>
                                                                    !! 输入消息
            integer(c_size_t), intent(in), value :: msglen          !! Message length <br>
                                                                    !! 消息长度
            integer(c_int8_t), intent(out) :: dgst(MD5_DIGEST_SIZE) !! Hash value <br>
                                                                    !! 杂凑值
        end subroutine md5_digest

        subroutine hex_to_bytes(in, inlen, out, outlen) bind(c, name='hex_to_bytes')
            import :: c_int8_t, c_size_t, c_signed_char
            character(kind=c_signed_char), intent(in) :: in(*) !! Hex string <br>
                                                               !! 十六进制字符串
            integer(c_size_t), intent(in), value :: inlen      !! Hex string length <br>
                                                               !! 十六进制字符串长度
            integer(c_int8_t), intent(out) :: out(*)           !! Bytes <br>
                                                               !! 字节
            integer(c_size_t), intent(in), value :: outlen     !! Bytes length <br>
                                                               !! 字节长度
        end subroutine hex_to_bytes

    end interface

end module SM3_module
