{ inputs, config, lib, pkgs, ... }:

{
  # JovianOS
  # Enable Steam Deck specific configurations.
  jovian.devices.steamdeck.enable = true;

  # Enable Steam Deck GUI
  jovian.steam.enable = true;

  # Enable Steam Deck GUI auto-start
  jovian.steam.autoStart = true;

  # Set Steam Deck GUI user
  jovian.steam.user = "brandon";

  # Enable plasma desktop manager.
  services.desktopManager.plasma6.enable = true;

  # Set Steam desktop mode session
  jovian.steam.desktopSession = "plasma";

  # Enable Decky Loader
  jovian.decky-loader.enable = true;

  # Required for first-time setup
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    maliit-keyboard # Needed for desktop mode lock screen
    kdePackages.discover # KDE Plasma app management
  ];

  services.flatpak.enable = true; # Needed for KDE Plasma app management

}
