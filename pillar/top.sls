base:
  '*':
    - default
# apply pillars specified in the 'custom' grain
{% set custom = salt['grains.get']('custom', {}) %}
{% if custom|length > 0 %}
  # iterate across configurations
  {% for key, val in custom.items() %}
    - {{ key }}
    #- 'custom:{{ key }}':
    #  - match: grain
    #  - {{ key }} # values are handeled internal to {{key}}.init
  {% endfor %}
{% endif %}
