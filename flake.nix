{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixosgen = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = inputs: with inputs; inputs.flake-utils.lib.eachDefaultSystem (system: let
		pkgs = import nixpkgs { inherit system; };
		name = "hackernel";
		virtualization_options = {
      qemu.options = [
        "-cpu host"
        "-machine accel=kvm"
      ];
      cores = 16;
      memorySize = 1024*4;
      diskSize = 1024*1;
    };

		clivm = nixosgen.nixosGenerate {
			inherit pkgs;
			format = "vm-nogui";
			modules = [
				./vm.nix
				{
					networking.hostName = name;
			    virtualisation = virtualization_options;
				}
			];
		};
		
	  simple_script = name: text: {
	    type = "app";
	    program = let
	      exec = pkgs.writeShellScript name text;
	    in "${exec}";
	  };
	in {
		apps.default = simple_script "spawn_vm" ''
			${clivm}/bin/run-${name}-vm
		'';
	});
}
