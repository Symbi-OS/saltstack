base:
  '*':
    - memcached
    - default
## apply pillars specified in the 'custom' grain
#{% set custom = salt['grains.get']('custom', '') %}
#{% if custom|length > 0 %}
#  # iterate across configurations
#    - {{ custom }}
#{% endif %}
