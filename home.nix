{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    starship
    lazygit
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Philippe Martens";
	email = "palmartens@ziggo.nl";
      };
    };
  };

  programs.bash.enable = true;
  programs.starship.enable = true;
}
