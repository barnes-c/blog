# blog

Source for [blog.barnes.biz](https://blog.barnes.biz): Hugo with the
[Blowfish](https://blowfish.page) theme (git submodule), served by nginx. Comments come from
a self-hosted Remark42 at `comments.barnes.biz`; deployment lives in
[barnes-c/homelab](https://github.com/barnes-c/homelab) under `manifests/blog-barnes-biz/`.

```sh
git clone --recurse-submodules git@github.com:barnes-c/blog.git
hugo new content posts/my-post.md   # set draft: false to publish
hugo server -D                      # preview at http://localhost:1313
```

Pushing a tag builds and pushes `ghcr.io/barnes-c/blog:<tag>` for amd64 and arm64.

Hugo is pinned to v0.167.0 in the `Dockerfile`; Blowfish v3.9.0 supports 0.164.0–0.167.0.
