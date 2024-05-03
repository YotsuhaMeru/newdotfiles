{
  disko.devices.disk = {
    disko1 = {
      type = "disk";
      device = "/dev/mmcblk0";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            label = "ESP";
            name = "ESP";
            start = "1MiB";
            end = "500MiB";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          luks = {
            size = "100%";
            label = "luks";
            content = {
              type = "luks";
              name = "luks";
              extraFormatArgs = ["--pbkdf argon2id --hash sha256"];
              extraOpenArgs = ["--allow-discards"];
              askPassword = true;
              content = {
                type = "filesystem";
                format = "xfs";
                extraArgs = ["-f"];
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
