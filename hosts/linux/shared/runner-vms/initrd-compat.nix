{
  inputs,
  lib,
  ...
}: let
  upstream = "${inputs.microvm}/nixos-modules/microvm";
  # Materialize the input before referencing it from a generated store file.
  microvmSource = builtins.path {
    path = inputs.microvm.outPath;
    name = "microvm-source";
  };
  # Patch at evaluation time so evaluating Linux guests on Darwin does not
  # require building a Linux derivation just to import the patched modules.
  patchModule = name: from: to: let
    source = builtins.readFile "${upstream}/${name}.nix";
  in
    assert lib.assertMsg (lib.all (needle: lib.hasInfix needle source) from)
    "MicroVM ${name}.nix changed; review or remove the initrd compatibility patch.";
      builtins.toFile "microvm-${name}-initrd-compat.nix" (lib.replaceStrings from to source);
in {
  # microvm f13928fe still defines and reads boot.initrd.systemd.enable,
  # which nixpkgs removed along with scripted initrd. Keep all other VM optimizations.
  # Remove this module and its import once the pinned microvm input includes
  # the upstream fix: https://github.com/microvm-nix/microvm.nix/pull/627
  disabledModules = [
    "${upstream}/optimization.nix"
    "${upstream}/mounts.nix"
  ];

  imports = [
    (patchModule "optimization" [
      ''        # Use systemd initrd for startup speed.
              # TODO: error mounting /nix/store on crosvm, kvmtool
              enable = lib.mkDefault (
                builtins.elem cfg.hypervisor [
                  "qemu"
                  "cloud-hypervisor"
                  "firecracker"
                  "stratovirt"
                ]);
      ''
    ] [""])
    (patchModule "mounts" [
        "config.boot.initrd.systemd.enable && "
        "import ../../lib"
      ] [
        ""
        # The patched module is a standalone store file, so preserve its import.
        "import ${microvmSource}/lib"
      ])
  ];
}
