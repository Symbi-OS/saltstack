wrk-build-depends:
  pkg.installed:
    - refresh: true
    - timeout: 300
    - pkgs:
       - openssl

extract-wrk-tarball:
  archive.extracted:
    - name: /tmp/wrk
    - source: https://github.com/wg/wrk/archive/4.0.2.tar.gz
    - source_hash: md5=2c9c7cbd2468152ccdd48587762c95c1
    - archive_format: tar
    - tar_options: z

install-wrk:
  cmd.run:
    - cwd: /tmp/wrk/wrk-4.0.2
    - name: |
        make -j {{salt['grains.get']('num_cpus', '1')}} || exit -1
    - timeout: 300
    - unless: test -d /tmp/wrk/wrk-4.0.2/wrk
    - require:
      - pkg: wrk-build-depends
      - archive: extract-wrk-tarball
