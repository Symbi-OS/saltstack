#include:
#  - khpy.moc.start
#  - exp.ebbrt
#  - fetalrecon.runbench

  build_app:
    cmd.run:
      - cwd: /tmp/ebbrt-contrib/apps/pcg-timer
      - name: |
          make -j || exit -1
      - timeout: 300
      - user: root
      - unless: test -x /tmp/ebbrt-contrib/apps/pcg-timer/hosted/build/Release/randping
