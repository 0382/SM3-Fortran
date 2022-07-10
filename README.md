# SM3-Fortran Hash

The SM3 password hashing algorithm is a hash algorithm similar to SHA-256, which belongs to the Chinese national standard. This library only contains a Fortran interface `SM3` of GmSSL and [its usage examples][7].

Based on interest, I learned about hashing algorithms, and I made some attempts, but [Fortran lacks unsigned integers][1], it is not suitable to implement hashing algorithms, and can only rely on C Binding.
Among open source code, [GmSSL][2] is popular for its high quality of code completion. Introducing GmSSL code entirely using [fpm][3] will cause compilation to fail,
The selected part of this library introduces GmSSL/SM3 algorithm code as a dependency of `SM3-Fortran`. The [Fortran Standard Library][4] already has the Hash algorithm,
the introduction of `SM3-Fortran` has the following implications:

- SM3 is a Chinese national standard hash algorithm, GmSSL is a Chinese-led project with Chinese feelings;
- SM3 security comparable to SHA-256;
- `SM3-Fortran` is a lightweight interface package, [Fortran-Stdlib][4]/Hash is relatively larger;
- `SM3-Fortran` only introduces the SM3 algorithm, providing a practical reference for Fortran Binding of other algorithms.

[1]: https://github.com/j3-fortran/fortran_proposals/issues/2
[2]: https://github.com/guanzhi/GmSSL
[3]: https://github.com/fortran-lang/fpm
[4]: https://github.com/fortran-lang/stdlib

> [中文](./README-CN.md) | English

## Dependencies

- [Fortran-lang/fpm][3] >= 0.6.0: for building packages and package distribution;
- [GNU/GCC][5] >= 9.4.0: for compiling C, Fortran code;

[5]: https://gcc.gnu.org/

## Getting Started

After downloading or cloning the repository locally, you can use fpm to compile the code:

````sh
cd SM3-Fortran
fpm run --example demo      # Run the example demo
fpm build --profile release
fpm build --profile release --flag "-DSM3_SSE3"     # Enable SSE3 optimization
````

It is also possible to add `SM3-Fortran` to a self-built fpm project:

````toml
[dependencies]
SM3-Fortran = { git = "https://github.com/zoziha/SM3-Fortran" }
````

Refer to [Chinese National Standard][6] for learning SM3 algorithm and [DEMO][7] for using `SM3-Fortran`.

[6]: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/1002389/files/302a3ada057c4a73830536d03e683110.pdf
[7]: ./example/demo.f90

## Reference link

- [SM3 National Standard](https://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002389.shtml)
- [GmSSL official website](http://gmssl.org/)