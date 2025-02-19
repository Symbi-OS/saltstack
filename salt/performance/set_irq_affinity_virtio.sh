#! /bin/bash
# Copyright 2013 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# For a single-queue / no MSI-X virtionet device, sets the IRQ affinities to
# processor 0. For this virtionet configuration, distributing IRQs to all
# processors results in comparatively high cpu utilization and comparatively
# low network bandwidth.
#
# For a multi-queue / MSI-X virtionet device, sets the IRQ affinities to the
# per-IRQ affinity hint. The virtionet driver maps each virtionet TX (RX) queue
# MSI-X interrupt to a unique single CPU if the number of TX (RX) queues equals
# the number of online CPUs. The mapping of network MSI-X interrupt vector to
# CPUs is stored in the virtionet MSI-X interrupt vector affinity hint. This
# configuration allows network traffic to be spread across the CPUs, giving
# each CPU a dedicated TX and RX network queue, while ensuring that all packets
# from a single flow are delivered to the same CPU.

function log() {
  echo $* >&2
}

function is_decimal_int() {
  [ "${1}" -eq "${1}" ] > /dev/null 2>&1
}

function set_channels() {
  ethtool -L "${1}" combined "${2}" > /dev/null 2>&1
}

log "Running $(basename $0)"
NET_DEVS=/sys/bus/virtio/drivers/virtio_net/virtio*

# Loop through all the virtionet devices and enable multi-queue
if [ -x /sbin/ethtool ]; then
  for dev in $NET_DEVS; do
    ETH_DEVS=${dev}/net/*
    for eth_dev in $ETH_DEVS; do
      eth_dev=$(basename "$eth_dev")
      if ! errormsg=$(ethtool -l "$eth_dev" 2>&1); then
        log "/sbin/ethtool says that $eth_dev does not support virtionet multiqueue: $errormsg"
        continue
      fi
      num_max_channels=$(ethtool -l "$eth_dev" | grep -m 1 Combined | cut -f2)
      [ "${num_max_channels}" -eq "1" ] && continue
      if is_decimal_int "$num_max_channels" && \
        set_channels "$eth_dev" "$num_max_channels"; then
        log "Set channels for $eth_dev to $num_max_channels"
      else
        log "Could not set channels for $eth_dev to $num_max_channels"
      fi
    done
  done
else
  log "/sbin/ethtool not found: cannot configure virtionet multiqueue"
fi

for dev in $NET_DEVS
do
    dev=$(basename "$dev")
    irq_dir=/proc/irq/*
    for irq in $irq_dir
    do
      smp_affinity="${irq}/smp_affinity"
      [ ! -f "${smp_affinity}" ] && continue
      # Classify this IRQ as virtionet intx, virtionet MSI-X, or non-virtionet
      # If the IRQ type is virtionet intx, a subdirectory with the same name as
      # the device will be present. If the IRQ type is virtionet MSI-X, then
      # a subdirectory of the form <device name>-<input|output>.N will exist.
      # In this case, N is the input (output) queue number, and is specified as
      # a decimal integer ranging from 0 to K - 1 where K is the number of
      # input (output) queues in the virtionet device.
      virtionet_intx_dir="${irq}/${dev}"
      virtionet_msix_dir_regex=".*/${dev}-(input|output)\.[0-9]+$"
      if [ -d "${virtionet_intx_dir}" ]; then
        # All virtionet intx IRQs are delivered to CPU 0
        log "Setting ${smp_affinity} to 01 for device ${dev}"
        echo "01" > ${smp_affinity}
        continue
      fi
      # Not virtionet intx, probe for MSI-X
      virtionet_msix_found=0
      for entry in ${irq}/${dev}*; do
        if [[ "$entry" =~ ${virtionet_msix_dir_regex} ]]; then
          virtionet_msix_found=1
        fi
      done
      affinity_hint="${irq}/affinity_hint"
      [ "$virtionet_msix_found" -eq 0 -o ! -f "${affinity_hint}" ] && continue

      # The affinity hint file contains a CPU mask, consisting of
      # groups of up to 8 hexadecimal digits, separated by a comma. Each bit
      # position in the CPU mask hex value specifies whether this interrupt
      # should be delivered to the corresponding CPU. For example, if bits 0
      # and 3 are set in the affinity hint CPU mask hex value, then the
      # interrupt should be delivered to CPUs 0 and 3. The virtionet device
      # driver should set only a single bit in the affinity hint per MSI-X
      # interrupt, ensuring each TX (RX) queue is used only by a single CPU.
      # The virtionet driver will only specify an affinity hint if the number of
      # TX (RX) queues equals the number of online CPUs. If no affinity hint is
      # specified for an IRQ, the affinity hint file will contain all zeros.
      affinity_cpumask=$(cat "${affinity_hint}")
      affinity_hint_enabled=0
      # Parse the affinity hint, skip if mask is invalid or is empty (all-zeros)
      OIFS=${IFS}
      IFS=","
      for cpu_bitmap in ${affinity_cpumask}; do
        bitmap_val=$(printf "%d" "0x${cpu_bitmap}" 2>/dev/null)
        if [ "$?" -ne 0 ]; then
          log "Invalid affinity hint ${affinity_hint}: ${affinity_cpumask}"
          affinity_hint_enabled=0
          break
        elif [ "${bitmap_val}" -ne 0 ]; then
          affinity_hint_enabled=1
        fi
      done
      IFS=${OIFS}
      if [ "${affinity_hint_enabled}" -eq 0 ]; then
        log "Cannot set IRQ affinity ${smp_affinity}, affinity hint disabled"
      else
        # Set the IRQ CPU affinity to the virtionet-initialized affinity hint
        log "Setting ${smp_affinity} to ${affinity_cpumask} for device ${dev}"
        echo "${affinity_cpumask}" > "${smp_affinity}"
      fi
    done
done
