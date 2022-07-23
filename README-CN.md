# SM3-Fortran 杂凑（哈希）

SM3 密码杂凑算法是一种类似 SHA-256 的哈希算法，属于中国国家标准，本库仅包含一个 GmSSL 的 Fortran 接口及[使用示例][7]。

基于兴趣，我学习了杂凑算法，我做了一些尝试，但是 [Fortran 缺乏无符号整形][1]，不适合实现哈希算法，只能依靠 C Binding。
在开源代码中，[GmSSL][2] 以其完成度较高的代码质量，受到欢迎。完全使用 [fpm][3] 引入 GmSSL 代码将导致编译失败，
本库选择部分引入 GmSSL/SM3 算法代码，作为 `SM3-Fortran` 的依赖。[Fortran 标准库][4]已经有了 Hash 算法，
引入 `SM3-Fortran` 有以下意义：

- SM3 是国家标准的杂凑算法，GmSSL 是国人主导的项目，有着国人情怀；
- SM3 安全性与 SHA-256 相当；
- `SM3-Fortran` 是一个轻量化接口包，[Fortran-Stdlib][4]/Hash 体量相对更大；
- `SM3-Fortran` 仅引入 SM3 算法，为其他算法的 Fortran Binding 提供实践参考。

[1]: https://github.com/j3-fortran/fortran_proposals/issues/2
[2]: https://github.com/guanzhi/GmSSL
[3]: https://github.com/fortran-lang/fpm
[4]: https://github.com/fortran-lang/stdlib

> 中文 | [English](./README.md)

## 依赖

- [Fortran-lang/fpm][3] >= 0.7.0：用于构建包和包分发；
- [GNU/GCC][5] >= 9.4.0：用于编译 C、Fortran 代码；

[5]: https://gcc.gnu.org/

## 开始

下载或克隆仓库到本地后，可使用 fpm 编译代码：

```sh
cd SM3-Fortran
fpm run --example demo      # 运行示例代码
fpm build --profile release
fpm build --profile release --flag "-DSM3_SSE3"     # 启动 SSE3 优化
```

也可以将 `SM3-Fortran` 添加到自建 fpm 项目：

```toml
[dependencies]
SM3-Fortran = { git = "https://gitee.com/fortran-stack/SM3-Fortran" }
```

学习 SM3 算法参考[国家标准][6]和 `SM3-Fortran` 使用请参考[示例][7]。

[6]: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/1002389/files/302a3ada057c4a73830536d03e683110.pdf
[7]: ./example/demo.f90

## 参考链接

- [SM3 国家标准](https://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002389.shtml)
- [GmSSL 官网](http://gmssl.org/)
