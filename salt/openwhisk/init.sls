include:
  - docker

ow-build-depends:
  pkg.installed:
    - refresh: true
    - pkgs:
      - git 
      - emacs 
      - build-essential 
      - libssl-dev 
      - libffi-dev 
      - python-dev 
      - python-pip 
      - couchdb

https://github.com/openwhisk/openwhisk.git:
  git.latest:
    - target: /root/openwhisk
    - user: root
    - submodules: true
    - require:
        - pkg: ow-build-depends 


ansible-run:
  cmd.run:
    - cwd: /root/openwhisk/tools/ubuntu-setup
    - name: source all.sh || exit -1
    - require:
      - git: https://github.com/openwhisk/openwhisk.git

export OW_DB=CouchDB
export OW_DB_USERNAME=ow_admin
export OW_DB_PASSWORD=password
export OW_DB_PROTOCOL=http
export OW_DB_HOST=127.0.0.1
export OW_DB_PORT=5984

curl -X PUT $COUCHDB_URL/_config/admins/ow_admin -d '"password"'

ansible-playbook setup.yml
../bin/wsk property set --auth $(cat files/auth.whisk.system) --apihost 172.17.0.1
