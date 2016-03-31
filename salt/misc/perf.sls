install_perf:
  pkg.installed:
    - refresh: true
    - pkgs: 
      - linux-tools-{{salt['grains.get']('kernelrelease', 'generic')}}
