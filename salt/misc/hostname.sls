hostname node{{ grains['id'].rsplit('.',1)[1] }}:
  cmd.run
