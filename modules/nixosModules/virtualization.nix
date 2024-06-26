{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.virtualisation;
in {
  options = {
    modules.virtualisation = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    virtualisation = {
      waydroid.enable = true;
      lxd.enable = false;
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu.ovmf.enable = true;
        qemu.runAsRoot = true;
      };
    };

    # Add binaries to path so that hooks can use it
    systemd = {
      services = {
        libvirtd = {
          path = let
            env = pkgs.buildEnv {
              name = "qemu-hook-env";
              paths = with pkgs; [bash libvirt kmod systemd ripgrep sd];
            };
          in [env];
        };
        pcscd.enable = false;
      };
      sockets.pcscd.enable = false;
    };

    # Link hooks to the correct directory
    system.activationScripts.libvirt-hooks.text = ''
      rm -rf /var/lib/libvirt/hooks/
      ln -Tsnf /etc/libvirt/hooks /var/lib/libvirt/hooks
    '';

    environment = {
      systemPackages = with pkgs; [virt-manager];
      etc = {
        "libvirt/hooks/qemu" = {
          text = ''
            #!/run/current-system/sw/bin/bash
            #
            # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
            #
            # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
            # After this file is installed, restart libvirt.
            # From now on, you can easily add per-guest qemu hooks.
            # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
            # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
            #

            GUEST_NAME="$1"
            HOOK_NAME="$2"
            STATE_NAME="$3"
            MISC="''${@:4}"

            BASEDIR="$(dirname $0)"

            HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

            set -e # If a script exits with an error, we should as well.

            # check if it's a non-empty executable file
            if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH"] && [ -x "$HOOKPATH" ]; then
                eval \"$HOOKPATH\" "$@"
            elif [ -d "$HOOKPATH" ]; then
                while read file; do
                    # check for null string
                    if [ ! -z "$file" ]; then
                      eval \"$file\" "$@"
                    fi
                done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
            fi
          '';
          mode = "0755";
        };

        "libvirt/hooks/kvm.conf" = {
          text = ''
            VIRSH_GPU_VIDEO=pci_0000_0c_00_0
            VIRSH_GPU_AUDIO=pci_0000_0c_00_1
          '';
          mode = "0755";
        };

        "libvirt/hooks/qemu.d/win/prepare/begin/start.sh" = {
          text = ''
            #!/run/current-system/sw/bin/bash

            # Debugging
            exec 19>/home/${config.var.username}/startlogfile
            BASH_XTRACEFD=19
            set -x

            # Load variables we defined
            source "/etc/libvirt/hooks/kvm.conf"

            # Change to performance governor
            echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

            # Isolate host to core 0
            systemctl set-property --runtime -- user.slice AllowedCPUs=0
            systemctl set-property --runtime -- system.slice AllowedCPUs=0
            systemctl set-property --runtime -- init.scope AllowedCPUs=0

            # Logout
            source "/home/${config.var.username}/logout.sh"

            # Stop display manager
            systemctl stop display-manager.service

            # Unbind VTconsoles
            echo 0 > /sys/class/vtconsole/vtcon0/bind
            echo 0 > /sys/class/vtconsole/vtcon1/bind

            # Unbind EFI Framebuffer
            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

            # Avoid race condition
            sleep 5

            # Unload AMD kernel modules
            modprobe -r amdgpu
            modprobe -r snd_hda_intel

            # Detach GPU devices from host
            #virsh nodedev-detach $VIRSH_GPU_VIDEO
            #virsh nodedev-detach $VIRSH_GPU_AUDIO

            # Load vfio module
            modprobe vfio
            modprobe vfio-pci
            modprobe vfio_iommu_type1
          '';
          mode = "0755";
        };

        "libvirt/hooks/qemu.d/macos/release/end/stop.sh" = {
          text = ''
            #!/run/current-system/sw/bin/bash

            # Debugging
            exec 19>/home/${config.var.username}/stoplogfile
            BASH_XTRACEFD=19
            set -x

            # Load variables we defined
            source "/etc/libvirt/hooks/kvm.conf"

            # Unload vfio module
            modprobe -r vfio
            modprobe -r vfio-pci
            modprobe -r vfio_iommu_type1

            # Attach GPU devices from host
            #virsh nodedev-reattach $VIRSH_GPU_VIDEO
            #virsh nodedev-reattach $VIRSH_GPU_AUDIO

            # Load AMD kernel modules
            modprobe amdgpu
            modprobe snd_hda_intel

            # Avoid race condition
            sleep 5

            # Bind EFI Framebuffer
            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

            # Bind VTconsoles
            echo 1 > /sys/class/vtconsole/vtcon0/bind
            echo 1 > /sys/class/vtconsole/vtcon1/bind

            # Start display manager
            systemctl start display-manager.service

            # Return host to all cores
            systemctl set-property --runtime -- user.slice AllowedCPUs=0-7
            systemctl set-property --runtime -- system.slice AllowedCPUs=0-7
            systemctl set-property --runtime -- init.scope AllowedCPUs=0-7

          '';
          mode = "0755";
        };
      };

      etc."gbinder.d/waydroid.conf".source =
        lib.mkForce
        (pkgs.writeText "waydroid.conf" ''
          [Protocol]
          /dev/binder = aidl3
          /dev/vndbinder = aidl3
          /dev/hwbinder = hidl

          [ServiceManager]
          /dev/binder = aidl3
          /dev/vndbinder = aidl3
          /dev/hwbinder = hidl

          [General]
          ApiLevel = 30
        '');
      etc."sysctl.d/90-max_map_count.conf".text = ''
        vm.max_map_count=1048576
      '';
      etc."sysctl.d/90-vfs_cache_pressure.conf".text = ''
        vm.vfs_cache_pressure = 10
      '';
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
