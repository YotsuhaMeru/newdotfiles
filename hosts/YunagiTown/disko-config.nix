{
  disko.devices = {
    disk = {
      vdb = {
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "500MiB";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "YunagiTown";
              start = "500MiB";
              end = "100%";
              part-type = "primary";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
              };
            }
          ];
        };
      };
    };
  };
}
